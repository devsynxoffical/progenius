import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:progenius/student/model/course_model/course_model.dart';
import 'package:progenius/student/utils/Api_Services/Urls.dart';
import 'package:progenius/student/utils/sharedPrefrense/sharedprefrence.dart';

class EnroledCoursesController extends GetxController {
  final Dio _dio = Dio();
  final isLoading = false.obs;
  final paidCourses = <FreeCourse>[].obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    fetchPaidCourses();
    super.onInit();
  }

  Future<void> fetchPaidCourses() async {
    isLoading.value = true;
    errorMessage.value = '';
    
    try {
      final String? token = await Sharedprefrence.getAccessToken();
      
      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      final response = await _dio.get(
        ApiUrls.studetnPaidCourse,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      print('✅ API Response: ${response.data}'); // Print full response

      if (response.statusCode == 200) {
        final List<dynamic> coursesData = response.data['data'] ?? [];
        paidCourses.value = coursesData
            .map((courseJson) => FreeCourse.fromJson(courseJson))
            .toList();
      } else {
        throw Exception('Failed to load courses: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ Dio Error: ${e.response?.data ?? e.message}');
      errorMessage.value = e.response?.data?['message'] ?? 
                         'Failed to fetch courses. Please try again.';
    } catch (e) {
      print('❌ Unexpected Error: $e');
      errorMessage.value = 'An unexpected error occurred. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshCourses() async {
    await fetchPaidCourses();
  }
}