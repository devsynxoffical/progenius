import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:progenuisadmin/model/course_model/chapter_model.dart';
import 'package:progenuisadmin/utils/apiUrls.dart';
import 'package:progenuisadmin/utils/app_colors/app_colors.dart';
import 'package:progenuisadmin/utils/sharedprefrence.dart';

class ChapterController extends GetxController {
  var isLoading = false.obs;
  var chapters = <Chapter>[].obs;
  var filteredChapters = <Chapter>[].obs;
  var searchQuery = "".obs;

  @override
  void onInit() {
    super.onInit();
    debounce(searchQuery, (_) => filterChapters(), time: Duration(milliseconds: 500));
  }

  /// 🔹 **Fetch Chapters by Course ID**
  Future<void> fetchChapters(String courseId) async {
    String? token = await Sharedprefrence.getAccessToken();
    if (token == null) {
      showErrorSnackbar("Unauthorized! Please login again.");
      return;
    }

    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse('${ApiUrls.getCourseChapter}/$courseId'),
        headers: _getHeaders(token),
      ).timeout(Duration(seconds: 10));

      if (_isSuccess(response.statusCode)) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          final dynamic chapterList = responseData['data']['chapters'];

          if (chapterList is List) {
            chapters.assignAll(chapterList.map((chapter) => Chapter.fromJson(chapter as Map<String, dynamic>)).toList());
            filteredChapters.assignAll(chapters);
          } else {
            throw Exception("Invalid response format: `chapters` is not a list.");
          }
        } else {
          throw Exception(responseData['message'] ?? "Failed to fetch chapters.");
        }
      } else {
        throw Exception("Error ${response.statusCode}: ${response.reasonPhrase}");
      }
    } catch (error) {
      showErrorSnackbar("Failed to fetch chapters: $error");
    } finally {
      isLoading(false);
    }
  }

  /// 🔹 **Add Chapter to a Specific Course**
  Future<void> addChapter(Chapter chapter, String courseId) async {
    String? token = await Sharedprefrence.getAccessToken();
    if (token == null) {
      showErrorSnackbar("Unauthorized! Please login again.");
      return;
    }

    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse(ApiUrls.getChapter),
        headers: _getHeaders(token),
        body: jsonEncode({
          "title": chapter.title,
          "course": courseId,
          "description": chapter.description,
          "isLocked": chapter.isLocked,
        }),
      ).timeout(Duration(seconds: 10));

      if (_isSuccess(response.statusCode)) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          chapters.add(Chapter.fromJson(responseData['data']));
          filterChapters();
          showSuccessSnackbar("Chapter added successfully.");
        } else {
          throw Exception(responseData['message'] ?? "Failed to add chapter.");
        }
      } else {
        throw Exception("Error ${response.statusCode}: ${response.reasonPhrase}");
      }
    } catch (error) {
      showErrorSnackbar("Failed to add chapter: $error");
    } finally {
      isLoading(false);
    }
  }

  /// 🔹 **Toggle Lock/Unlock Chapter**
  Future<void> toggleLock(Chapter chapter) async {
    try {
      isLoading(true);
      bool updatedLockStatus = !(chapter.isLocked ?? false);

      final response = await http.patch(
        Uri.parse('${ApiUrls.getChapterLock_Unlock}/${chapter.id}'),
        headers: _getHeaders(await Sharedprefrence.getAccessToken()),
        body: jsonEncode({"isLocked": updatedLockStatus}),
      );

      if (_isSuccess(response.statusCode)) {
        int index = chapters.indexWhere((c) => c.id == chapter.id);
        if (index != -1) {
          chapters[index] = chapter.copyWith(isLocked: updatedLockStatus);
          chapters.refresh();
        }
        showSuccessSnackbar("Chapter status updated!");
      } else {
        final errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message'] ?? "Failed to update chapter.");
      }
    } catch (error) {
      showErrorSnackbar("Failed to update chapter: $error");
    } finally {
      isLoading(false);
    }
  }

  /// 🔹 **Search Filter**
  void filterChapters() {
    if (searchQuery.value.isEmpty) {
      filteredChapters.assignAll(chapters);
    } else {
      filteredChapters.assignAll(
        chapters.where((chapter) => chapter.title!.toLowerCase().contains(searchQuery.value.toLowerCase())).toList(),
      );
    }
  }

  /// 🔹 **Delete Chapter by ID**
  Future<void> deleteChapter(String id) async {
    String? token = await Sharedprefrence.getAccessToken();
    if (token == null) {
      showErrorSnackbar("Unauthorized! Please login again.");
      return;
    }

    try {
      final response = await http.delete(
        Uri.parse("${ApiUrls.getChapter}/$id"),
        headers: _getHeaders(token),
      );

      if (_isSuccess(response.statusCode)) {
        chapters.removeWhere((chapter) => chapter.id == id);
        filteredChapters.removeWhere((chapter) => chapter.id == id);
        showSuccessSnackbar("Chapter deleted successfully.");
      } else {
        throw Exception("Failed to delete Chapter");
      }
    } catch (error) {
      showErrorSnackbar("Something went wrong! $error");
    }
  }

  /// 🔹 **Reusable Headers**
  Map<String, String> _getHeaders(String? token) {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  /// 🔹 **Success Response Check**
  bool _isSuccess(int statusCode) {
    return statusCode == 200 || statusCode == 201 || statusCode == 204;
  }

  /// 🔹 **Show Success Snackbar**
  void showSuccessSnackbar(String message) {
    Get.snackbar("Success", message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppColors.primary,
        colorText: AppColors.whitColor);
  }

  /// 🔹 **Show Error Snackbar**
  void showErrorSnackbar(String message) {
    Get.snackbar("Error", message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: AppColors.whitColor);
  }
}

