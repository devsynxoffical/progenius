import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progenius/student/controller/course_controller/paid_course/paid_course_controller.dart';
import 'package:progenius/student/utils/appColors.dart';
import 'package:progenius/student/view/NavBarPages/Course_content/free_course/card.dart';

class PaidContentPage extends StatelessWidget {
  final PaidCourseController controller = Get.put(PaidCourseController());

  PaidContentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Paid Learning Content',
          style: TextStyle(color: AppColors.whitColor),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.pink],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.whitColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), // ✅ Adds padding for better UI
        child: Obx(() {
          final paidCourses =
              controller.courses.where((course) => course.status == "PAID").toList();

          return RefreshIndicator(
            onRefresh: () async {
              await controller.fetchCourses(); // ✅ Fetch latest courses
            },
            child: paidCourses.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(), // ✅ Ensures smooth scrolling
                    itemCount: paidCourses.length,
                    itemBuilder: (context, index) {
                      final course = paidCourses[index];
                      return FreeCourseCard(course: course);
                    },
                  ),
          );
        }),
      ),
    );
  }
}
