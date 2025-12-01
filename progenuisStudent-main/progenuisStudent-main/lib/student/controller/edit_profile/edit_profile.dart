import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progenius/student/model/profile.dart';
import 'package:progenius/student/utils/Api_Services/Urls.dart';
import 'dart:convert';
import 'package:progenius/student/utils/sharedPrefrense/sharedprefrence.dart';
import 'package:image/image.dart' as img;
import 'package:progenius/student/view/auth/login/login.dart';

class EditProfileController extends GetxController {
  final String baseUrl = "${ApiUrls.SgetProfile}";

  // Profile Data
  var profile = Rx<ProfileModel?>(null);

  // Form Controllers
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
   var emailController = TextEditingController();

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


Future<File> convertImageToJpg(File file) async {
  final image = img.decodeImage(file.readAsBytesSync());
  if (image == null) throw Exception("Failed to decode image");

  // Convert the image to JPG format
  final jpgFile = File('${file.path}.jpg')
    ..writeAsBytesSync(img.encodeJpg(image, quality: 85));

  return jpgFile;
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
        emailController.text = profile.value?.email ?? "";

        // Set profile image from API if available
        if (profile.value?.profileImage != null) {
          selectedImage.value = File(profile.value!.profileImage!);
        }
      } else if (response.statusCode == 401) {
         Get.offAll(()=>LoginPage());
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  // Update Profile

Future<void> updateProfile() async {
  if (nameController.text.trim().isEmpty) {
    Get.snackbar("Error", "Please fill in the name field.");
    return;
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
      ..fields['phoneNumber'] = phoneController.text.trim() 
       ..fields['email'] = emailController.text.trim()
       ..fields['status'] = "ACTIVE"; // Change to the correct field expected by API

    // ✅ Ensure the correct field name for the image (API expects "file")
    String imageFieldName = "file"; 

    // ✅ Convert image to jpg before uploading
    if (selectedImage.value != null) {
      print("Selected image path: ${selectedImage.value!.path}");
      final convertedFile = await convertImageToJpg(selectedImage.value!);
      request.files.add(
        await http.MultipartFile.fromPath(
          imageFieldName, // ✅ Match API expected field name
          convertedFile.path,
          contentType: MediaType('image', 'jpeg'), // ✅ Set correct content type
        ),
      );
    }

    var streamedResponse = await request.send().timeout(Duration(seconds: 30));
    var response = await http.Response.fromStream(streamedResponse);

    print("API Response Status: ${response.statusCode}");
    print("API Response Body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      Get.snackbar("Success", "Profile updated successfully!");
      getProfile(); // Refresh profile data
    } else {
      Get.snackbar("Error", "Failed to update profile. Status code: ${response.statusCode}");
    }
  } catch (e) {
    print("Error updating profile: $e");
    Get.snackbar("Error", "An error occurred. Please try again.");
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
