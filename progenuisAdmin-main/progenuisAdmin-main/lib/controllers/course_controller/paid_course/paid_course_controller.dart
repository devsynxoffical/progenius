import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:progenuisadmin/model/course_model/course_model.dart';
import 'package:progenuisadmin/utils/apiUrls.dart';
import 'package:progenuisadmin/utils/sharedprefrence.dart';

class PaidCourseController extends GetxController {
  var isLoading = false.obs;
  var courses = <FreeCourse>[].obs;

  final String baseUrl = ApiUrls.paidCourse;
  final String addCourseUrl = ApiUrls.addCourse;

  @override
  void onInit() {
    super.onInit();
    fetchCourses();
  }

  /// 🔹 **Fetch All Paid Courses**
  Future<void> fetchCourses() async {
    String? token = await Sharedprefrence.getAccessToken();
    if (token == null) {
      _showErrorSnackbar("Unauthorized! Please login again.");
      return;
    }

    try {
      isLoading(true);

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['success'] == true && responseData['data'] is List) {
          courses.assignAll(
            (responseData['data'] as List)
                .map((course) => FreeCourse.fromJson(course))
                .toList(),
          );
        } else {
          throw Exception(responseData['message'] ?? "Failed to fetch courses.");
        }
      } else if (response.statusCode == 401) {
        _showErrorSnackbar("Session Expired. Please login again.");
      } else {
        throw HttpException("Error ${response.statusCode}: ${response.reasonPhrase}");
      }
    } on TimeoutException {
      _showErrorSnackbar("Request timed out. Please check your internet connection.");
    } on SocketException {
      _showErrorSnackbar("No internet connection. Please try again.");
    } catch (error) {
      _showErrorSnackbar("Failed to fetch courses: $error");
    } finally {
      isLoading(false);
    }
  }

  /// 🔹 **Add a New Course**
  Future<void> addCourse(FreeCourse course, File imageFile, String status) async {
    String? token = await Sharedprefrence.getAccessToken();
    if (token == null) {
      _showErrorSnackbar("Unauthorized! Please login again.");
      return;
    }

    final allowedExtensions = ['jpg', 'jpeg', 'png'];
    final fileExtension = imageFile.path.split('.').last.toLowerCase();

    if (!allowedExtensions.contains(fileExtension)) {
      _showErrorSnackbar("Only JPEG and PNG files are allowed.");
      return;
    }

    try {
      isLoading(true);

      final mimeType = fileExtension == 'png' ? 'image/png' : 'image/jpeg';

      final request = http.MultipartRequest('POST', Uri.parse(addCourseUrl))
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['title'] = course.title ?? ""
        ..fields['description'] = course.description ?? ""
        ..fields['status'] = status
        ..files.add(await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
          contentType: MediaType.parse(mimeType),
        ));

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(responseBody);
        if (responseData['success'] == true) {
          courses.add(FreeCourse.fromJson(responseData['data']));
          _showSuccessSnackbar("Course added successfully");
        } else {
          throw Exception(responseData['message'] ?? "Failed to add course.");
        }
      } else {
        throw HttpException("Error ${response.statusCode}: ${response.reasonPhrase}");
      }
    } on TimeoutException {
      _showErrorSnackbar("Request timed out. Please check your internet connection.");
    } on SocketException {
      _showErrorSnackbar("No internet connection. Please try again.");
    } catch (error) {
      _showErrorSnackbar("Failed to add course: $error");
    } finally {
      isLoading(false);
    }
  }

  /// 🔹 **Delete a Course**
  Future<void> deleteCourse(String id) async {
    String? token = await Sharedprefrence.getAccessToken();
    if (token == null) {
      _showErrorSnackbar("Unauthorized! Please login again.");
      return;
    }

    try {
      final response = await http.delete(
        Uri.parse("${ApiUrls.deleteCourse}/$id"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        courses.removeWhere((course) => course.id == id);
        _showSuccessSnackbar("Course deleted successfully");
      } else {
        throw Exception("Failed to delete course");
      }
    } catch (e) {
      _showErrorSnackbar("Something went wrong!");
    }
  }

  /// 🔹 **Show Success Snackbar**
  void _showSuccessSnackbar(String message) {
    Future.delayed(Duration.zero, () {
      if (!Get.isSnackbarOpen) {
        Get.snackbar(
          "Success",
          message,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    });
  }

  /// 🔹 **Show Error Snackbar**
  void _showErrorSnackbar(String message) {
    Future.delayed(Duration.zero, () {
      if (!Get.isSnackbarOpen) {
        Get.snackbar(
          "Error",
          message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    });
  }
}

