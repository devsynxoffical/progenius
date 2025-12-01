import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:progenuisadmin/utils/apiUrls.dart';
import 'package:progenuisadmin/utils/sharedprefrence.dart';

class UpdateCourseController extends GetxController {
  Future<void> updateCourseTitle(String courseId, String newTitle, String status) async {
    final String url = '${ApiUrls.addCourse}/$courseId'; // Ensure correct endpoint

    try {
      String? token = await Sharedprefrence.getAccessToken();
      if (token == null) {
        _showErrorSnackbar("Unauthorized! Please login again.");
        return;
      }

      if (courseId.isEmpty) {
        _showErrorSnackbar("Invalid course ID!");
        return;
      }

      print("PATCH Request to: $url");
      print("Token: $token");
      print("Request Body: ${jsonEncode({"title": newTitle})}");

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "title": newTitle,
          "status":status,
         
          }),
      );

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Course title updated successfully",
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        _showErrorSnackbar("Failed to update course title: ${response.body}");
      }
    } catch (e) {
      _showErrorSnackbar("Something went wrong: $e");
    }
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
