import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ForgotPasswordController extends GetxController {
  var isLoading = false.obs;
  var emailController = TextEditingController();
  var emailError = ''.obs;

  void submitForgotPassword() {
    if (emailController.text.isEmpty) {
      emailError.value = "Email is required";
      return;
    }
    // Simulate loading
    isLoading.value = true;
    Future.delayed(Duration(seconds: 2), () {
      isLoading.value = false;
      Get.snackbar("Success", "Password reset link sent to your email.");
    });
  }
}