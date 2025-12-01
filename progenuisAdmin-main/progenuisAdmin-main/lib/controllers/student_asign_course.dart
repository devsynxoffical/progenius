// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:progenuisadmin/utils/apiUrls.dart';
// import 'package:progenuisadmin/utils/sharedprefrence.dart';

// class StudentCourseController extends GetxController {
//   var isLoading = false.obs;
//   var allUsers = <Map<String, String>>[].obs; // Store all users
//   var filteredUsers = <Map<String, String>>[].obs; // Store filtered users for search
//   var selectedStudents = <String>[].obs; // Store selected student IDs

//   @override
//   void onInit() {
//     super.onInit();
//     fetchAllUsers();
//   }

//   // ✅ Fetch all users from API
//   Future<void> fetchAllUsers() async {
//     try {
//       isLoading(true);

//       String? token = await Sharedprefrence.getAccessToken();
//       if (token == null || token.isEmpty) {
//         Get.snackbar("Error", "Unauthorized! Please login again.");
//         return;
//       }

//       print("Fetching all users from: ${ApiUrls.AallUser}");
//       print("Authorization Token: $token");

//       var response = await http.get(
//         Uri.parse(ApiUrls.AallUser),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//       );

//       print("Response Status Code: ${response.statusCode}");
//       print("Response Body: ${response.body}");

//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);
//         print("API Response Data: $data");

//         if (data['data'] != null && data['data'] is List) {
//           // ✅ Ensure all values are converted to Strings
//           allUsers.value = (data['data'] as List)
//               .map((user) => {
//                     "id": user['_id'].toString(),
//                     "name": user['fullName']?.toString() ?? "Unknown User", // Explicitly convert name to String
//                     "email" : user['email']?.toString() ?? 'UnKnown Email'
//                   })
//               .toList();
//           filteredUsers.value = allUsers; // Initialize filteredUsers with all users
//         } else {
//           print("Unexpected data format: $data");
//           Get.snackbar("Error", "Unexpected data structure.");
//         }
//       } else {
//         Get.snackbar("Error", "Failed to fetch users. Status Code: ${response.statusCode}");
//       }
//     } catch (e) {
//       Get.snackbar("Error", "An error occurred: $e");
//     } finally {
//       isLoading(false);
//     }
//   }
  

//   // ✅ Update course with selected students
//   Future<void> updateStudentsInCourse(String courseId) async {
//     try {
//       isLoading(true);

//       String? token = await Sharedprefrence.getAccessToken();
//       if (token == null || token.isEmpty) {
//         Get.snackbar("Error", "Unauthorized! Please login again.");
//         return;
//       }

//       var requestBody = jsonEncode({
//         "customerIds": selectedStudents, // ✅ Send selected student IDs
//         "courseId": courseId,
//       });

//       print("Request Body: $requestBody");

//       var response = await http.patch(
//         Uri.parse(ApiUrls.studentList),
//         headers: {
//           'Authorization': 'Bearer $token',
//           'Content-Type': 'application/json',
//         },
//         body: requestBody,
//       );

//       if (response.statusCode == 200) {
//           // ✅ Show Success Snackbar
//            Get.snackbar(
//             "Success",
//               "Students assigned successfully!",
//              snackPosition: SnackPosition.TOP,
//              backgroundColor: Colors.green,
//                colorText: Colors.white,
//              duration: Duration(seconds: 2),
//            );
//       } else {
//         Get.snackbar("Error", "Failed to update students. Status Code: ${response.statusCode}");
//       }
//     } catch (e) {
//       Get.snackbar("Error", "An error occurred: $e");
//     } finally {
//       isLoading(false);
//     }
//   }

//   // ✅ Select or deselect students
//   void toggleStudentSelection(String studentId) {
//     if (selectedStudents.contains(studentId)) {
//       selectedStudents.remove(studentId);
//     } else {
//       selectedStudents.add(studentId);
//     }
//   }

//   // ✅ Filter users based on search query
//   void filterUsers(String query) {
//     if (query.isEmpty) {
//       // If the query is empty, show all users
//       filteredUsers.value = allUsers;
//     } else {
//       // Filter users whose names contain the query (case-insensitive)
//       filteredUsers.value = allUsers
//           .where((user) => user['name']!.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     }
//   }
// }



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:progenuisadmin/utils/apiUrls.dart';
import 'package:progenuisadmin/utils/sharedprefrence.dart';

class StudentCourseController extends GetxController {
  var isLoading = false.obs;
  var allUsers = <Map<String, String>>[].obs; // Store all users
  var filteredUsers = <Map<String, String>>[].obs; // Store filtered users for search
  var selectedStudents = <String>[].obs; // Store selected student IDs

  @override
  void onInit() {
    super.onInit();
    fetchAllUsers();
  }

  // ✅ Fetch all users from API with improved exception handling
  Future<void> fetchAllUsers() async {
    isLoading(true);
    try {
      final token = await Sharedprefrence.getAccessToken();
      if (token == null || token.isEmpty) {
        Get.snackbar("Error", "Unauthorized! Please login again.");
        return;
      }

      final response = await http.get(
        Uri.parse(ApiUrls.AallUser),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          if (data['data'] != null && data['data'] is List) {
            allUsers.value = (data['data'] as List)
                .map((user) => {
                      "id": user['_id'].toString(),
                      "name": user['fullName']?.toString() ?? "Unknown User",
                      "email": user['email']?.toString() ?? 'UnKnown Email',
                    })
                .toList();
            filteredUsers.value = allUsers;
          } else {
            debugPrint("Unexpected data format: $data");
            Get.snackbar("Error", "Unexpected data structure.");
          }
        } on FormatException catch (e) {
          debugPrint("JSON FormatException: $e");
          Get.snackbar("Error", "Invalid response format.");
        } catch (e) {
          debugPrint("Data parsing error: $e");
          Get.snackbar("Error", "Error parsing user data.");
        }
      } else {
        debugPrint("Failed to fetch users. Status Code: ${response.statusCode}");
        Get.snackbar("Error", "Failed to fetch users. Status Code: ${response.statusCode}");
      }
    } on http.ClientException catch (e) {
      debugPrint("HTTP ClientException: $e");
      Get.snackbar("Error", "Network error occurred.");
    } on Exception catch (e) {
      debugPrint("General Exception: $e");
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading(false);
    }
  }
  

  // ✅ Update course with selected students (improved exception handling)
  Future<void> updateStudentsInCourse(String courseId) async {
    isLoading(true);
    try {
      final token = await Sharedprefrence.getAccessToken();
      if (token == null || token.isEmpty) {
        Get.snackbar("Error", "Unauthorized! Please login again.");
        return;
      }

      final requestBody = jsonEncode({
        "customerIds": selectedStudents,
        "courseId": courseId,
      });

      final response = await http.patch(
        Uri.parse(ApiUrls.studentList),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          "Students assigned successfully!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
      } else {
        debugPrint("Failed to update students. Status Code: ${response.statusCode}");
        Get.snackbar("Error", "Failed to update students. Status Code: ${response.statusCode}");
      }
    } on http.ClientException catch (e) {
      debugPrint("HTTP ClientException: $e");
      Get.snackbar("Error", "Network error occurred.");
    } on Exception catch (e) {
      debugPrint("General Exception: $e");
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading(false);
    }
  }

  // ✅ Select or deselect students
  void toggleStudentSelection(String studentId) {
    if (selectedStudents.contains(studentId)) {
      selectedStudents.remove(studentId);
    } else {
      selectedStudents.add(studentId);
    }
  }

  // ✅ Filter users based on search query
  void filterUsers(String query) {
    if (query.isEmpty) {
      // If the query is empty, show all users
      filteredUsers.value = allUsers;
    } else {
      // Filter users whose names contain the query (case-insensitive)
      filteredUsers.value = allUsers
          .where((user) => user['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
}


