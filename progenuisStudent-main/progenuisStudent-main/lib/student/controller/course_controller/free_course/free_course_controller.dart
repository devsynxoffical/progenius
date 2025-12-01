import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:progenius/student/model/course_model/course_model.dart';
import 'package:progenius/student/utils/Api_Services/Urls.dart';
import 'package:progenius/student/utils/sharedPrefrense/sharedprefrence.dart';
import 'package:progenius/student/view/auth/login/login.dart';

class FreeCourseController extends GetxController {
  var isLoading = false.obs;
  var courses = <FreeCourse>[].obs;
  final String baseUrl = ApiUrls.freeCourse;
  final _storage = GetStorage();
  static const String _cacheKey = 'free_courses_cache';

  @override
  void onInit() {
    super.onInit();
    _loadCachedCourses(); // Load from cache first
    fetchCourses(); // Then fetch fresh data
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

  Future<void> fetchCourses() async {
    String? token = await Sharedprefrence.getAccessToken();
    if (token == null) {
      _showSafeSnackbar("Error", "Unauthorized! Please login again.");
      return;
    }

    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success'] == true && responseData['data'] is List) {
          final List<dynamic> courseList = responseData['data'];
          List<FreeCourse> parsedCourses = await compute(parseCourses, courseList);
          courses.assignAll(parsedCourses);
          _saveCourses(parsedCourses); // Cache the data
        } else {
          throw Exception(responseData['message'] ?? "Failed to fetch courses.");
        }
      } else if (response.statusCode == 401) {
        _handleUnauthorized();
      } else {
        throw HttpException("Error ${response.statusCode}: ${response.reasonPhrase}");
      }
    } on TimeoutException {
      _showSafeSnackbar("Error", "Request timed out. Showing cached data.");
    } on SocketException {
      _showSafeSnackbar("Offline Mode", "No internet. Showing cached courses.");
    } catch (error) {
      _showSafeSnackbar("Error", "Failed to fetch courses: ${error.toString()}");
    } finally {
      isLoading(false);
    }
  }

  // Safe snackbar implementation
  void _showSafeSnackbar(String title, String message) {
    if (Get.isSnackbarOpen) Get.back();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.key.currentContext != null) {
        Get.snackbar(
          title,
          message,
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 3),
        );
      } else {
        // Fallback: Try again after a short delay
        Future.delayed(Duration(milliseconds: 300), () => _showSafeSnackbar(title, message));
      }
    });
  }

  void _handleUnauthorized() {
    _showSafeSnackbar("Session Expired", "Please login again.");
    Future.delayed(Duration(seconds: 1), () {
      if (Get.key.currentContext != null) {
        Get.offAll(() => LoginPage());
      }
    });
  }
}

List<FreeCourse> parseCourses(List<dynamic> courseList) {
  return courseList.map((course) => FreeCourse.fromJson(course)).toList();
}
