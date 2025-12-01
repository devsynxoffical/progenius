import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progenius/navBar.dart';
import 'package:progenius/student/utils/Api_Services/Urls.dart';
import 'package:progenius/student/utils/appColors.dart';
import 'package:progenius/student/utils/sharedPrefrense/sharedprefrence.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:progenius/student/view/auth/login/login.dart';

class LoginController extends GetxController {
  // Text Editing Controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Observables for validation and loading
  var emailError = ''.obs;
  var passwordError = ''.obs;
  var isLoading = false.obs;

  // Observable for password visibility
  var isPasswordVisible = false.obs;

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Login function with API integration
Future<void> login() async {
  if (!validateForm()) return;

  isLoading.value = true;
  final url = Uri.parse(ApiUrls.Slogin);
  final body = jsonEncode({
    'email': emailController.text.trim(),
    'password': passwordController.text.trim(),
  });

  try {
    final client = http.Client();
    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    client.close(); // Ensure connection closes

    print("Response Status: ${response.statusCode}");
    print("Raw Response: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      if (responseData['success'] == true && responseData['data'] != null) {
        String accessToken = responseData['data']['accessToken'];
        await Sharedprefrence.saveAccessToken(accessToken);
        Get.snackbar('Success', 'Logged in successfully!',
            backgroundColor: AppColors.secondary, colorText: Colors.white);
        await Future.delayed(Duration(seconds: 1));
        Get.offAll(() => MainNavigationPage());
      } else {
        throw Exception("Invalid response data");
      }
    } else {
      final responseData = jsonDecode(response.body);
      Get.snackbar('Error', responseData['message'] ?? 'Login failed!',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  } catch (e) {
    print("Login Error: $e");
    Get.snackbar('Error', 'An error occurred. Check your internet connection.',
        backgroundColor: Colors.red, colorText: Colors.white);
  } finally {
    isLoading.value = false;
  }
}


  // Validation logic
  bool validateForm() {
    bool isValid = true;

    // Email validation
    if (emailController.text.isEmpty) {
      emailError.value = 'Email is required';
      isValid = false;
    } else if (!GetUtils.isEmail(emailController.text)) {
      emailError.value = 'Enter a valid email';
      isValid = false;
    } else {
      emailError.value = '';
    }

    // Password validation
    if (passwordController.text.isEmpty) {
      passwordError.value = 'Password is required';
      isValid = false;
    } else if (passwordController.text.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
      isValid = false;
    } else {
      passwordError.value = '';
    }

    return isValid;
  }


// logout

Future<void> logout() async {
  try {
    // Remove access token from SharedPreferences
    await Sharedprefrence.clearAccessToken();
    
    // Navigate back to the login screen
    Get.to(()=>LoginPage()); // Replace '/login' with your actual login route

    // Show success message
    Get.snackbar(
      'Logged Out',
      'You have been logged out successfully!',
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.secondary,
      colorText: Colors.white,
    );
  } catch (e) {
    print("Logout Error: $e");
    Get.snackbar(
      'Error',
      'An error occurred while logging out. Please try again.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}


}