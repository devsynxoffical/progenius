import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:progenuisadmin/model/lesson_model/lesson_model.dart';
import 'package:progenuisadmin/utils/apiUrls.dart';
import 'package:progenuisadmin/utils/app_colors/app_colors.dart';
import 'package:progenuisadmin/utils/sharedprefrence.dart';

class LessonController extends GetxController {
  var isLoading = false.obs;
  var lessons = <LessonModel>[].obs;

  /// **🔹 Fetch All Lessons by Chapter ID**
  Future<void> getAllChapterLesson(String chapterId) async {
    final token = await _getAuthToken();
    if (token == null) return;

    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse('${ApiUrls.getAllChapterLesson}/$chapterId'),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      );

      print('--------------- ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null && data['data']['lessons'] is List) {
          lessons.assignAll((data['data']['lessons'] as List)
              .map((lesson) => LessonModel.fromJson(lesson))
              .toList());
        } else {
          throw Exception('Invalid response format');
        }
      }
    } catch (e) {
      print("Error fetching lessons: $e");
    } finally {
      isLoading(false);
    }
  }

  /// **🔹 Add Lesson with Video, Quiz, & PDFs**
  Future<void> addLesson({
    required String chapterId,
    required String title,
    required List<Map<String, String>> videos,
    required List<Map<String, String>> quizes,
    required List<File> pdfFiles,
  }) async {
    final token = await _getAuthToken();
    if (token == null) return;

    try {
      isLoading(true);
      var request = http.MultipartRequest("POST", Uri.parse(ApiUrls.addLesson))
        ..headers['Authorization'] = 'Bearer $token'
        ..fields.addAll({'title': title, 'chapter': chapterId})
        ..fields['videos'] = jsonEncode(videos)
        ..fields['quizes'] = jsonEncode(quizes);

      for (var pdf in pdfFiles) {
        request.files.add(await http.MultipartFile.fromPath(
          'pdfs',
          pdf.path,
          contentType: MediaType('application', 'pdf'),
        ));
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        Get.back();
        getAllChapterLesson(chapterId);
      } else {
        throw Exception('Failed to add lesson: $responseBody');
      }
    } catch (e) {
      print("Error adding lesson: $e");
    } finally {
      isLoading(false);
    }
  }

  /// **🔹 Update Lesson (Title, Video, Quiz)**
  Future<void> updateLesson({
    required String lessonId,
    required String title,
    required List<Map<String, String>> videos,
    required List<Map<String, String>> quizes,
  }) async {
    final token = await _getAuthToken();
    if (token == null) return;

    try {
      isLoading(true);
      final response = await http.patch(
        Uri.parse("${ApiUrls.getLessonDetails}/$lessonId"),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: jsonEncode({'title': title, 'videos': videos, 'quizes': quizes}),
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Lesson updated successfully",
            snackPosition: SnackPosition.TOP,
            backgroundColor: AppColors.primary,
            colorText: AppColors.whitColor);
      } else {
        throw Exception('Failed to update lesson');
      }
    } catch (e) {
      print("Error updating lesson: $e");
    } finally {
      isLoading(false);
    }
  }

  /// **🔹 Update PDFs for a Lesson**
  Future<void> updateLessonPDFs({
    required String lessonId,
    required List<File> pdfFiles,
  }) async {
    final token = await _getAuthToken();
    if (token == null) return;

    try {
      isLoading(true);
      var request = http.MultipartRequest("PATCH", Uri.parse("${ApiUrls.updatePDF}/$lessonId"))
        ..headers['Authorization'] = 'Bearer $token';

      for (var pdf in pdfFiles) {
        request.files.add(await http.MultipartFile.fromPath(
          'pdfs',
          pdf.path,
          contentType: MediaType('application', 'pdf'),
        ));
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        Get.snackbar("Success", "PDFs updated successfully",
            snackPosition: SnackPosition.TOP,
            backgroundColor: AppColors.primary,
            colorText: AppColors.whitColor);
        getAllChapterLesson(lessonId);
      } else {
        throw Exception('Failed to update PDFs: $responseBody');
      }
    } catch (e) {
      print("Error updating PDFs: $e");
    } finally {
      isLoading(false);
    }
  }

  /// **🔹 Delete Lesson**
  Future<void> deleteLesson(String id) async {
    final token = await _getAuthToken();
    if (token == null) return;

    try {
      final response = await http.delete(
        Uri.parse("${ApiUrls.getLessonDetails}/$id"),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        lessons.removeWhere((lesson) => lesson.id == id);
        Get.snackbar("Success", "Lesson deleted successfully",
            snackPosition: SnackPosition.TOP,
            backgroundColor: AppColors.primary,
            colorText: AppColors.whitColor);
      } else {
        throw Exception('Failed to delete lesson');
      }
    } catch (e) {
      print("Error deleting lesson: $e");
    }
  }

  /// **🔹 Delete PDF from a Lesson**
  Future<void> deleteLessonPDF({
    required String lessonId,
    required String pdfId,
  }) async {
    final token = await _getAuthToken();
    if (token == null) return;

    try {
      isLoading(true);
      final response = await http.patch(
        Uri.parse("${ApiUrls.deletePDF}/$lessonId"),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: jsonEncode({"pdfIds": pdfId}),
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "PDF deleted successfully",
            snackPosition: SnackPosition.TOP,
            backgroundColor: AppColors.primary,
            colorText: AppColors.whitColor);
      } else {
        throw Exception('Failed to delete PDF');
      }
    } catch (e) {
      print("Error deleting PDF: $e");
    } finally {
      isLoading(false);
    }
  }

  /// **🔹 Helper Function: Get Auth Token**
  Future<String?> _getAuthToken() async {
    final token = await Sharedprefrence.getAccessToken();
    if (token == null) {
      Get.snackbar("Error", "Unauthorized! Please login again.",
          backgroundColor: Colors.red, colorText: AppColors.whitColor);
    }
    return token;
  }





Future<void> deleteLessonContent({
  required String lessonId,
  required String contentType, // 'videos' or 'quizes'
  required String contentId, // The specific video/quiz ID to be removed
}) async {
  final token = await _getAuthToken();
  if (token == null) {
    Get.snackbar("Error", "Authentication token is missing");
    return;
  }

  try {
    isLoading(true);

    print("Fetching lesson details from: ${ApiUrls.getLessonDetails}/$lessonId");

    // ✅ Fetch the lesson details first
    final response = await http.get(
      Uri.parse("${ApiUrls.getLessonDetails}/$lessonId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> lessonData = json.decode(response.body);

      print("Lesson Data Fetched Successfully: $lessonData");

      print("Content Type: $contentType | Content ID to Remove: $contentId");

      // ✅ Fetch the existing list of videos or quizzes
      List<Map<String, dynamic>> existingContent = [];
      if (lessonData.containsKey(contentType)) {
        existingContent = List<Map<String, dynamic>>.from(lessonData[contentType]);
      }

      // ✅ Remove ONLY the selected item from the array
      List<Map<String, dynamic>> updatedContent = existingContent.where((item) {
        String itemId = item.containsKey("_id") ? item["_id"].toString() : item["id"].toString();
        return itemId != contentId; // Keep items that don't match the target ID
      }).toList();

      print("Updated Content After Deletion: $updatedContent");

      // ✅ Prepare the PATCH request payload
      Map<String, dynamic> updatePayload = {
        contentType: updatedContent, // Update only the modified array
      };

      print("PATCH Payload: $updatePayload");

      // ✅ Send PATCH request to update only the modified array
      final patchResponse = await http.patch(
        Uri.parse("${ApiUrls.getLessonDetails}/$lessonId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(updatePayload),
      );

      if (patchResponse.statusCode == 200) {
        Get.snackbar("Success", "Deleted successfully");
        getAllChapterLesson(lessonId); // Refresh data
      } else {
        Get.snackbar("Error", "Failed to update content");
        print("PATCH Response: ${patchResponse.body}");
      }
    } else {
      Get.snackbar("Error", "Failed to fetch lesson details");
      print("GET Response: ${response.body}");
    }
  } catch (e) {
    print("Error deleting content: $e");
    Get.snackbar("Error", "Something went wrong");
  } finally {
    isLoading(false);
  }
}

}



