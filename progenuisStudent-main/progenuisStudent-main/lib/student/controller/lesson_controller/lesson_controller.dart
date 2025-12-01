import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:progenius/student/model/lesson_model/lesson_model.dart';
import 'package:progenius/student/utils/Api_Services/Urls.dart';
import 'package:progenius/student/utils/appColors.dart';
import 'package:progenius/student/utils/sharedPrefrense/sharedprefrence.dart';
import 'package:progenius/student/view/paymentPage/paymentPage.dart';

class LessonController extends GetxController {
  var isLoading = false.obs;
  var lessons = <LessonModel>[].obs;

  /// 🔹 **Fetch All Lessons of a Chapter**
  Future<void> getAllChapterLesson(String chapterId) async {
    String? token = await Sharedprefrence.getAccessToken();
    if (token == null) {
      Get.snackbar("Error", "Unauthorized! Please login again.");
      return;
    }

    try {
      isLoading(true);

      final apiUrl = '${ApiUrls.getAllChapterLesson}/$chapterId';
      print("Fetching lessons from: $apiUrl");

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      print("API Response Status Code: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        if (data['data'] != null && data['data']['lessons'] is List) {
          lessons.assignAll(
            (data['data']['lessons'] as List).map((lesson) => LessonModel.fromJson(lesson)).toList(),
          );
        } else {
          throw Exception("Invalid response format: `data['lessons']` is not a list.");
        }
      } else {
        _showAccessDeniedDialog(data['message'] ?? "Access Denied");
      }
    } catch (e) {
      print("Error fetching lessons: $e");
      Get.snackbar("Error", "Failed to fetch lessons. Please try again.");
    } finally {
      isLoading(false);
    }
  }

  /// 🔹 **Show Professional Access Denied Dialog**
  void _showAccessDeniedDialog(String message) {
    if (!Get.isDialogOpen!) {
      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // ✅ Rounded corners
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            width: Get.width * 0.85, // ✅ Responsive width
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, color: Colors.redAccent, size: 50),
                const SizedBox(height: 12),

                // ✅ Title
                const Text(
                  "Access Restricted",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // ✅ Message
                Text(
                  message,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // ✅ Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Get.to(()=>PaymentDetailsPage());
                        
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Upgrade Plan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text(
                        "Close",
                        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false, // ✅ Prevent accidental dismiss
      );
    }
  }


}
