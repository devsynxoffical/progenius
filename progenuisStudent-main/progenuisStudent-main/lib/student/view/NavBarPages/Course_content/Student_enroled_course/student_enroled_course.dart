import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progenius/student/controller/course_controller/single_std_course/single_std_course.dart';
import 'package:progenius/student/utils/appColors.dart';
import 'package:progenius/student/view/NavBarPages/Course_content/free_course/card.dart';

class StudentEnrolledCourse extends StatelessWidget {
  StudentEnrolledCourse({super.key});

  final EnroledCoursesController controller = Get.put(EnroledCoursesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whitColor,
      appBar: AppBar(
        title: const Text('Your Courses'),
        titleTextStyle: TextStyle(
          color: AppColors.whitColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: AppColors.whitColor),
        centerTitle: true,
        backgroundColor: AppColors.secondary,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: controller.fetchPaidCourses,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.paidCourses.isEmpty) {
          return const Center(
            child: Text('No paid courses found'),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshCourses,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.paidCourses.length,
            itemBuilder: (context, index) {
              final course = controller.paidCourses[index];
              return FreeCourseCard(course: course);
            },
          ),
        );
      }),
    );
  }
}