import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:progenuisadmin/model/profile/profile.dart';
import 'package:progenuisadmin/utils/apiUrls.dart';
import 'package:progenuisadmin/utils/sharedprefrence.dart';

class EditProfileController extends GetxController {
  final String baseUrl = "${ApiUrls.AgetProfile}";
 
  // Nullable Profile Data using Model
  var profile = Rx<ProfileModel?>(null);

  // Form Controllers
  var nameController = TextEditingController();
  var phoneController = TextEditingController();

  // Error Messages
  var phoneError = ''.obs;

  // Loading State
  var isLoading = false.obs;
  var selectedImage = Rx<File?>(null);

  // Pick an image from the gallery
  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }


Future<File> compressImage(File file) async {
  final image = img.decodeImage(file.readAsBytesSync());
  if (image == null) throw Exception("Failed to decode image");

  // Resize the image to a maximum width of 800 pixels
  final resizedImage = img.copyResize(image, width: 800);

  // Save the resized image to a temporary file
  final compressedFile = File('${file.path}_compressed.jpg')
    ..writeAsBytesSync(img.encodeJpg(resizedImage, quality: 85));

  return compressedFile;
}

  // Get Profile Data
  Future<void> getProfile() async {
    try {
      isLoading.value = true;

      String? token = await Sharedprefrence.getAccessToken();
      if (token == null) {
        Get.snackbar("Error", "Unauthorized! Please login again.");
        return;
      }

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse.containsKey("data")) {
          profile.value = ProfileModel.fromJson(jsonResponse);
        } else {
          Get.snackbar("Error", "Invalid API response format");
        }

        nameController.text = profile.value?.fullName ?? "";
        phoneController.text = profile.value?.phoneNumber ?? "";
      } else {
    
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  // Update Profile
Future<void> updateProfile() async {
  // Validate fields
  if (nameController.text.trim().isEmpty) {
    Get.snackbar("Error", "Please fill in the name field.");
    return;
  }

  if (phoneController.text.trim().isEmpty) {
    phoneError.value = "Please fill in the phone field.";
    return;
  } else {
    phoneError.value = '';
  }

  isLoading.value = true;

  try {
    String? token = await Sharedprefrence.getAccessToken();
    if (token == null) {
      Get.snackbar("Error", "Unauthorized! Please login again.");
      return;
    }

    var request = http.MultipartRequest('PATCH', Uri.parse(baseUrl))
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['fullName'] = nameController.text.trim()
      ..fields['phoneNumber'] = phoneController.text.trim();

    // Add compressed image file if selected
    if (selectedImage.value != null) {
      print("Selected image path: ${selectedImage.value!.path}");
      final compressedFile = await compressImage(selectedImage.value!);
      request.files.add(
        await http.MultipartFile.fromPath(
          'file', // Ensure this key matches the API's expected key for the image
          compressedFile.path,
        ),
      );
    }

    // Send the request with a timeout
    var streamedResponse = await request.send().timeout(Duration(seconds: 30));
    var response = await http.Response.fromStream(streamedResponse);

    print("API Response Status: ${response.statusCode}");
    print("API Response Body: ${response.body}");

    // Handle the response
    if (response.statusCode == 200) {
      Get.snackbar("Success", "Profile updated successfully!");
      getProfile(); // Refresh the profile data
    } else {
      // Handle specific error codes
      if (response.statusCode == 400) {
        Get.snackbar("Error", "Invalid data. Please check your inputs.");
      } else if (response.statusCode == 401) {
        Get.snackbar("Error", "Unauthorized. Please login again.");
      } else if (response.statusCode == 500) {
        Get.snackbar("Error", "Server error. Please try again later.");
      } else {
        Get.snackbar("Error", "Failed to update profile. Status code: ${response.statusCode}");
      }
    }
  } catch (e) {
    print("Error updating profile: $e");
    if (e is SocketException || e is http.ClientException) {
      Get.snackbar("Error", "Network error. Please check your connection and try again.");
    } else {
      Get.snackbar("Error", "An error occurred. Please try again.");
    }
  } finally {
    isLoading.value = false;
  }
}
 
  @override
  void onInit() {
    super.onInit();
    getProfile();
  }
}