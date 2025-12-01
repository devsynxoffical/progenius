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
import 'package:progenuisadmin/view/auth/login/login.dart';

class FreeCourseController extends GetxController {
  var isLoading = false.obs;
  var courses = <FreeCourse>[].obs;

  final String baseUrl = ApiUrls.freeCourse;
  final String addCourseUrl = ApiUrls.addCourse;

  @override
  void onInit() {
    super.onInit();
    fetchCourses();
  }

  /// 🔹 **Fetch All Courses**
  Future<void> fetchCourses() async {
    String? token = await Sharedprefrence.getAccessToken();
    if (token == null) {
      Get.snackbar("Error", "Unauthorized! Please login again.");
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
       Get.to(()=>LoginPage());
      } else {
        throw HttpException("Error ${response.statusCode}: ${response.reasonPhrase}");
      }
    } on TimeoutException {
      Get.snackbar("Error", "Request timed out. Please check your internet connection.");
    } on SocketException {
      Get.snackbar("Network Error", "No internet connection. Please try again.");
    } catch (error) {
      Get.snackbar("Error", "Failed to fetch courses: $error", backgroundColor: Colors.red);
    } finally {
      isLoading(false);
    }
  }

  /// 🔹 **Add Course with Image**
  Future<void> addCourse(FreeCourse course, File imageFile, String status) async {
    String? token = await Sharedprefrence.getAccessToken();
    if (token == null) {
      Get.snackbar("Error", "Unauthorized! Please login again.");
      return;
    }

    final allowedExtensions = ['jpg', 'jpeg', 'png'];
    final fileExtension = imageFile.path.split('.').last.toLowerCase();

    if (!allowedExtensions.contains(fileExtension)) {
      Get.snackbar("Invalid File", "Only JPEG and PNG files are allowed.");
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
          Get.snackbar("Success", "Course added successfully", backgroundColor: Colors.green);
        } else {
          throw Exception(responseData['message'] ?? "Failed to add course.");
        }
      } else {
        throw HttpException("Error ${response.statusCode}: ${response.reasonPhrase}");
      }
    } on TimeoutException {
      Get.snackbar("Error", "Request timed out. Please check your internet connection.");
    } on SocketException {
      Get.snackbar("Network Error", "No internet connection. Please try again.");
    } catch (error) {
      Get.snackbar("Error", "Failed to add course: $error", backgroundColor: Colors.red);
    } finally {
      isLoading(false);
    }
  }

  /// 🔹 **Delete Course**
  Future<void> deleteCourse(String id) async {
    String? token = await Sharedprefrence.getAccessToken();
    if (token == null) {
      Get.snackbar("Error", "Unauthorized! Please login again.");
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
        Get.snackbar("Success", "Course deleted successfully", backgroundColor: Colors.green);
      } else {
        throw Exception("Failed to delete course");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong!", backgroundColor: Colors.red);
    }
  }
}

