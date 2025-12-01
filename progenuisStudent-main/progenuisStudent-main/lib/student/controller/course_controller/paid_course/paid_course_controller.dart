import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:progenius/student/model/course_model/course_model.dart';
import 'package:progenius/student/utils/Api_Services/Urls.dart';
import 'package:progenius/student/utils/sharedPrefrense/sharedprefrence.dart';

class PaidCourseController extends GetxController {
  var isLoading = false.obs;
  var courses = <FreeCourse>[].obs;
  final String baseUrl = ApiUrls.paidCourse;
  final _storage = GetStorage();
  static const String _cacheKey = 'paid_courses_cache';

  @override
  void onInit() {
    super.onInit();
    _loadCachedCourses();
    fetchCourses();
  }

  /// Load courses from local cache
  void _loadCachedCourses() {
    try {
      final cachedData = _storage.read(_cacheKey);
      if (cachedData != null && cachedData is List) {
        List<FreeCourse> cachedCourses = cachedData
            .map((json) => FreeCourse.fromJson(json))
            .toList();
        courses.assignAll(cachedCourses);
      }
    } catch (e) {
      debugPrint('Error loading cached courses: $e');
    }
  }

  /// Save courses to local cache
  void _saveCourses(List<FreeCourse> courseList) {
    try {
      final jsonList = courseList.map((course) => course.toJson()).toList();
      _storage.write(_cacheKey, jsonList);
    } catch (e) {
      debugPrint('Error saving courses to cache: $e');
    }
  }

  /// 🔹 Fetch All Courses
  Future<void> fetchCourses() async {
    if (isLoading.value) return; // Prevent multiple simultaneous fetches

    isLoading.value = true;

    try {
      final String? token = await Sharedprefrence.getAccessToken();
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
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          final List<dynamic> courseList = responseData['data'];
          courses.value = courseList.map((course) => FreeCourse.fromJson(course)).toList();
          _saveCourses(courses); // Cache the data
        } else {
          throw Exception(responseData['message'] ?? "Failed to fetch courses.");
        }
      } else if (response.statusCode == 401) {
        Get.snackbar("Session Expired", "Please login again.");
        // Handle logout or redirect to login
      } else {
        throw HttpException("Error ${response.statusCode}: ${response.reasonPhrase}");
      }
    } on TimeoutException {
      Get.snackbar("Error", "Request timed out. Showing cached data.");
    } on SocketException {
      Get.snackbar("Offline Mode", "No internet. Showing cached courses.");
    } catch (error) {
      Get.snackbar("Error", "Failed to fetch courses: $error");
    } finally {
      isLoading.value = false;
    }
  }
}
