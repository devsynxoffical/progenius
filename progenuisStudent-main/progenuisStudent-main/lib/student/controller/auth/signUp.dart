import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:progenius/student/utils/Api_Services/Urls.dart';
import 'package:progenius/student/view/auth/login/login.dart';

class SigupController extends GetxController {
  // Controllers for text fields
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();

  // Error messages
  var nameError = ''.obs;
  var emailError = ''.obs;
  var phoneError = ''.obs;
  var passwordError = ''.obs;

  // Password visibility
  var isPasswordVisible = false.obs;

  // Loading state
  var isLoading = false.obs;

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  @override
  void onInit() {
    super.onInit();
    // Add real-time validation listeners
    emailController.addListener(_validateEmail);
    passwordController.addListener(_validatePassword);
    phoneController.addListener(_validatePhone);
    nameController.addListener(_validateName);
  }

  @override
  void dispose() {
    // Remove listeners
    emailController.removeListener(_validateEmail);
    passwordController.removeListener(_validatePassword);
    phoneController.removeListener(_validatePhone);
    nameController.removeListener(_validateName);
    // Dispose controllers
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _validateName() {
    if (nameController.text.trim().isEmpty) {
      nameError.value = 'Please enter your full name';
    } else {
      nameError.value = '';
    }
  }

  void _validateEmail() {
    final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (emailController.text.trim().isEmpty) {
      emailError.value = 'Email is required';
    } else if (!emailRegex.hasMatch(emailController.text.trim())) {
      emailError.value = 'Please enter a valid email address';
    } else {
      emailError.value = '';
    }
  }

  void _validatePhone() {
    if (phoneController.text.trim().isEmpty) {
      phoneError.value = 'Phone number is required';
    } else if (phoneController.text.length < 10) {
      phoneError.value = 'Please enter a valid phone number';
    } else {
      phoneError.value = '';
    }
  }

  void _validatePassword() {
    final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#\$%^&*(),.?":{}|<>]).{8,100}$');
    if (passwordController.text.trim().isEmpty) {
      passwordError.value = 'Password is required';
    } else if (!passwordRegex.hasMatch(passwordController.text.trim())) {
      passwordError.value = 'Password must have 8+ chars, 1 Upper, 1 Lower, 1 Number, 1 Special char';
    } else {
      passwordError.value = '';
    }
  }

  // Validate fields
  bool validateFields() {
    bool isValid = true;

    if (nameController.text.trim().isEmpty) {
      nameError.value = 'Please enter your full name';
      isValid = false;
    } else {
      nameError.value = '';
    }

    // Email Validation
    final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (emailController.text.trim().isEmpty || !emailRegex.hasMatch(emailController.text.trim())) {
      emailError.value = 'Please enter a valid email address';
      isValid = false;
    } else {
      emailError.value = '';
    }

    if (phoneController.text.trim().isEmpty || phoneController.text.length < 10) {
      phoneError.value = 'Please enter a valid phone number';
      isValid = false;
    } else {
      phoneError.value = '';
    }

    // Password Validation (Backend requires: 1 Upper, 1 Lower, 1 Number, 1 Special, 8-15 chars)
    // We will enforce 8+ chars and complexity here to give immediate feedback.
    final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#\$%^&*(),.?":{}|<>]).{8,100}$');
    if (passwordController.text.trim().isEmpty) {
      passwordError.value = 'Password is required';
      isValid = false;
    } else if (!passwordRegex.hasMatch(passwordController.text.trim())) {
      passwordError.value = 'Password must have 8+ chars, 1 Upper, 1 Lower, 1 Number, 1 Special char';
      isValid = false;
    } else {
      passwordError.value = '';
    }

    return isValid;
  }

Future<void> register() async {
  if (!validateFields()) {
    return;
  }

  isLoading.value = true;

  try {
    final url = Uri.parse(ApiUrls.Sregiter);
    print("Registering User...");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'fullName': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phoneNumber': phoneController.text.trim(),
        'password': passwordController.text.trim(),
      }),
    );

    final responseData = jsonDecode(response.body);
    print("Response Data: $responseData"); // Debugging API response
    

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Check API response message
      if (responseData['success'] == true) {
        Get.snackbar(
          'Success',
          responseData['message'] ?? 'Registration successful!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        await Future.delayed(Duration(seconds: 2)); // Small delay for better UX
        Get.offAll(() => LoginPage()); // Navigate to login
      } else {
        Get.snackbar(
          'Error',
          responseData['message'] ?? 'Something went wrong!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
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
    print("Error: $e");
    Get.snackbar(
      'Error',
      'An error occurred. Please check your internet connection.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  } finally {
    isLoading.value = false; // Ensure loading state resets
  }
}

}
