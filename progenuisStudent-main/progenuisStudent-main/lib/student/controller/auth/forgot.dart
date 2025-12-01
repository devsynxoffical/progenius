import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:progenius/student/utils/Api_Services/Urls.dart';
import 'package:progenius/student/utils/appColors.dart';
import 'package:progenius/student/utils/sharedPrefrense/sharedprefrence.dart';
import 'package:progenius/student/view/auth/forget_password/change_password.dart';
import 'package:progenius/student/view/auth/forget_password/otp_screen.dart';
import 'package:progenius/student/view/auth/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPasswordController extends GetxController {
  final TextEditingController otpController = TextEditingController();
  final fogotEmailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
final isLoading = false.obs;
  final Dio dio = Dio();
 Future<void> sendOTP() async {
    if (fogotEmailController.text.isNotEmpty) {
      Map<String, dynamic> map = {
        "email": fogotEmailController.text,
        
        };

      // Set loading to true before making the API call
      isLoading.value = true;

      try {
        final value = await dio.post(
          ApiUrls.sendOTP.trim(),
          data: map,
        );

        if (value.statusCode == 200 || value.statusCode == 201) {
          // Navigate to the OTP verification page on success
          Get.to(() => OtpVerificationPage(email: fogotEmailController.text));
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("otp", value.data["data"]["hashedOtp"]);
         Get.snackbar(
             "OTP", "Please check your email", backgroundColor: AppColors.secondary, colorText: Colors.white
          );
        } else {
          // Show error message if login fails
          throw Exception('Failed to Send OTP $map');
        }
      } catch (error) {
      
      } finally {
        // Always set loading to false after the API call
        isLoading.value = false;
      }
    } else {
      // Show warning if email is empty
      Get.snackbar(
        "Valid Email",
        'Please enter a valid email address',
         backgroundColor: AppColors.secondary, colorText: Colors.white
      );
    }
  }

Future<void> verifyOTP() async {
  if (otpController.text.length != 6) {
    Get.snackbar(
      "Verify",
      'Please enter a valid 6-digit OTP.',
      backgroundColor: Colors.red,
      colorText: Colors.white
    );
    return;
  }

  isLoading.value = true;
  
  try {
    final prefs = await SharedPreferences.getInstance();
    final hashedToken = prefs.getString("otp");
    
    if (hashedToken == null) {
      throw Exception('OTP session expired. Please request a new OTP.');
    }

    final Map<String, dynamic> requestBody = {
      "hashedOtp": hashedToken,
      "otp": otpController.text,
      "email": fogotEmailController.text,
    };

    print("Verifying OTP with data: $requestBody");

    final response = await http.post(
      Uri.parse(ApiUrls.verifyOTP.trim()),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestBody),
    );

    print("OTP Verification Response: ${response.statusCode} - ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = json.decode(response.body);
      final token = responseData["data"]["token"];
      
      if (token == null) {
        throw Exception('Token not received from server');
      }

      // Save the token using SharedPrefrence class
      await Sharedprefrence.saveAccessToken(token);
      
      Get.snackbar(
        "Success", 
        'OTP verified successfully!', 
        backgroundColor: AppColors.secondary, 
        colorText: Colors.white
      );
      
      Get.to(() => ChangePasswordPage());
    } else {
      final errorData = json.decode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to verify OTP');
    }
  } catch (error) {
    print("OTP Verification Error: $error");
    Get.snackbar(
      "Error",
      error.toString(),
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  } finally {
    isLoading.value = false;
  }
}

Future<void> resetPassword() async {
  isLoading.value = true;
  
  try {
    // 1. Get the token that was saved during OTP verification
    String? token = await Sharedprefrence.getAccessToken();
    print("Reset Password Token: $token");
    
    if (token == null || token.isEmpty) {
      throw Exception('Authentication token not found. Please verify OTP again.');
    }

    // 2. Prepare request data
    Map<String, dynamic> requestBody = {
      "password": passwordController.text,
      // Some APIs require token in body, some in header - include both if needed
      "token": token
    };
    
    print("Reset Password Request Body: $requestBody");

    // 3. Make the API call with token in Authorization header
    final response = await http.patch(
      Uri.parse(ApiUrls.resetPassword.trim()),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode(requestBody),
    );

    print("Reset Password Response: ${response.statusCode} - ${response.body}");

    // 4. Handle response
    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.snackbar(
        'Success', 
        'Password Reset Successfully',
        backgroundColor: AppColors.secondary, 
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
      
      // Clear the token after successful password reset
      await Sharedprefrence.clearAccessToken();
      Get.offAll(() => LoginPage());
    } else {
      final errorResponse = json.decode(response.body);
      final errorMessage = errorResponse['message'] ?? 'Failed to reset password';
      throw Exception('$errorMessage (Status: ${response.statusCode})');
    }
  } catch (error) {
    print("Reset Password Error Details: $error");
    Get.snackbar(
      'Error', 
      error.toString().replaceAll('Exception: ', ''),
      backgroundColor: Colors.red, 
      colorText: Colors.white,
      duration: Duration(seconds: 3),
    );
  } finally {
    isLoading.value = false;
  }
}
}