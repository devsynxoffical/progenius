import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:progenuisadmin/nav_bar.dart';
import 'package:progenuisadmin/utils/apiUrls.dart';
import 'dart:convert';
import 'package:progenuisadmin/utils/sharedprefrence.dart';
import 'package:progenuisadmin/view/auth/login/login.dart';

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
    if (!validateForm()) {
      return;
    }

    isLoading.value = true; // Start loading

    try {
      final url = Uri.parse(ApiUrls.Alogin);
      print("Attempting to log in...");
      print("URL: $url");

      final body = jsonEncode({
        'email': emailController.text.trim(),
        'password': passwordController.text.trim(),
      });

      print("Request Body: $body");

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse the response
        final responseData = jsonDecode(response.body);

        // Ensure response contains data and accessToken
        if (responseData['success'] == true && responseData['data'] != null) {
          String accessToken = responseData['data']['accessToken'];

          // Save the access token to SharedPreferences
          await Sharedprefrence.saveAccessToken(accessToken);

          // Show success message
          Get.snackbar(
            'Success',
            'Logged in successfully!',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          // Delay to ensure smooth transition
          await Future.delayed(Duration(seconds: 1));

          // Navigate to MainNavigationPage
          Get.offAll(() => MainNavigationPage());
        } else {
          Get.snackbar(
            'Error',
            'Invalid response from server!',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        // Handle API response errors
        final responseData = jsonDecode(response.body);
        Get.snackbar(
          'Error',
          responseData['message'] ?? 'Something went wrong!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 4),
        );
      }
    } catch (e) {
      // Handle network errors
      Get.snackbar(
        'Error',
        'An error occurred. Please check your internet connection.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false; // Stop loading
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

  @override
  void onClose() {
    // Dispose the controllers when the controller is closed
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

// logout
  void logout() async {
    await Sharedprefrence.clearAccessToken();
    Get.offAll(() => LoginPage()); // Redirect to login screen
  }

}