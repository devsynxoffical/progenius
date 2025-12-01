// import 'dart:async';
// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:progenius/student/model/course_model/chapter_model.dart';
// import 'package:progenius/student/utils/Api_Services/Urls.dart';
// import 'package:progenius/student/utils/sharedPrefrense/sharedprefrence.dart';


// class ChapterController extends GetxController {
//   var isLoading = false.obs;
//   var chapters = <Chapter>[].obs;
//   var filteredChapters = <Chapter>[].obs;
//   var searchQuery = "".obs;

//   @override
//   void onInit() {
//     super.onInit();
//     debounce(searchQuery, (_) => filterChapters(), time: Duration(milliseconds: 500));
//   }

//   /// 🔹 **Fetch Chapters by Course ID**
// Future<void> fetchChapters(String courseId) async {
//   String? token = await Sharedprefrence.getAccessToken();
//   if (token == null) {
//     Get.snackbar("Error", "Unauthorized! Please login again.");
//     return;
//   }
// print("========$token");
//   try {
//     isLoading.value = true;
//     final response = await http.get(
//       Uri.parse('${ApiUrls.getCourseChapter}/$courseId'),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-Type': 'application/json',
//       },
//     ).timeout(Duration(seconds: 10));

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       final Map<String, dynamic> responseData = jsonDecode(response.body);
//       print("API Response: $responseData"); // ✅ Debugging Log

//       if (responseData['success'] == true) {
//         final dynamic courseData = responseData['data']; // ✅ Extract course data

//         if (courseData is Map<String, dynamic>) {
//           final dynamic chapterList = courseData['chapters']; // ✅ Extract `chapters`

//           if (chapterList is List) {
//             chapters.assignAll(
//               chapterList.map((chapter) => Chapter.fromJson(chapter as Map<String, dynamic>)).toList(),
//             );
//           } else {
//             throw Exception("Invalid response format: `chapters` is not a list.");
//           }
//         } else {
//           throw Exception("Invalid response format: `data` is not a map.");
//         }

//         // ✅ Do not filter out locked chapters here
//         filteredChapters.assignAll(chapters);
//       } else {
//         throw Exception(responseData['message'] ?? "Failed to fetch chapters.");
//       }
//     } else {
//       throw Exception("Error ${response.statusCode}: ${response.reasonPhrase}");
//     }
//   } catch (error) {
//     print("Error fetching chapters: $error");
//     Get.snackbar("Error", "Failed to fetch chapters: ${error.toString()}");
//   } finally {
//     isLoading.value = false;
//   }
// }



//   /// 🔹 **Search Filter**
//   void filterChapters() {
//     if (searchQuery.value.isEmpty) {
//       filteredChapters.assignAll(chapters);
//     } else {
//       filteredChapters.assignAll(
//         chapters.where((chapter) => chapter.title!.toLowerCase().contains(searchQuery.value.toLowerCase())).toList(),
//       );
//     }
//   }
// }



import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:progenius/student/model/course_model/chapter_model.dart';
import 'package:progenius/student/utils/Api_Services/Urls.dart';
import 'package:progenius/student/utils/sharedPrefrense/sharedprefrence.dart';

class ChapterController extends GetxController {
  var isLoading = false.obs;
  var chapters = <Chapter>[].obs;
  var filteredChapters = <Chapter>[].obs;
  var searchQuery = "".obs;

  @override
  void onInit() {
    super.onInit();
    debounce(searchQuery, (_) => filterChapters(), time: const Duration(milliseconds: 300));
  }

  /// 🔹 **Fetch Chapters by Course ID**
  Future<void> fetchChapters(String courseId) async {
    String? token = await Sharedprefrence.getAccessToken();
    if (token == null) {
      Get.snackbar("Error", "Unauthorized! Please login again.");
      return;
    }

    try {
      isLoading(true); // ✅ Start loading state

      final response = await http.get(
        Uri.parse('${ApiUrls.getCourseChapter}/$courseId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          final courseData = responseData['data'];

          if (courseData is Map<String, dynamic> && courseData['chapters'] is List) {
            final chapterList = courseData['chapters'] as List;

            chapters.assignAll(chapterList.map((chapter) => Chapter.fromJson(chapter)).toList());
            filteredChapters.assignAll(chapters); // ✅ Sync search results
          } else {
            throw Exception("Invalid response format: `chapters` missing or incorrect.");
          }
        } else {
          throw Exception(responseData['message'] ?? "Failed to fetch chapters.");
        }
      } else {
        throw Exception("Error ${response.statusCode}: ${response.reasonPhrase}");
      }
    } on TimeoutException {
      Get.snackbar("Error", "Request timed out. Please check your internet connection.");
    } on Exception catch (error) {
      Get.snackbar("Error", "Failed to fetch chapters: ${error.toString()}");
    } finally {
      isLoading(false); // ✅ Stop loading state
    }
  }

  /// 🔹 **Search Filter (Optimized)**
  void filterChapters() {
    if (searchQuery.value.isEmpty) {
      filteredChapters.assignAll(chapters);
    } else {
      final lowerCaseQuery = searchQuery.value.toLowerCase();
      filteredChapters.assignAll(
        chapters.where((chapter) => chapter.title?.toLowerCase().contains(lowerCaseQuery) ?? false).toList(),
      );
    }
  }
}

