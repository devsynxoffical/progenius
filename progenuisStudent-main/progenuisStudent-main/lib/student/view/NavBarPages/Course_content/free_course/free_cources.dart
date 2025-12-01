// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:progenius/student/controller/course_controller/free_course/free_course_controller.dart';
// import 'package:progenius/student/utils/appColors.dart';
// import 'package:progenius/student/view/NavBarPages/Course_content/free_course/card.dart';

// class FreeContentPage extends StatelessWidget {
//   final FreeCourseController controller = Get.put(FreeCourseController());

//   FreeContentPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Free Learning Content',
//           style: TextStyle(color: AppColors.whitColor),
//         ),
//         centerTitle: true,
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.purple, Colors.pink],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//         leading: IconButton(
//           onPressed: () => Get.back(),
//           icon: const Icon(Icons.arrow_back_ios, color: AppColors.whitColor),
//         ),
//       ),
//       body: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), // ✅ Adds padding for better UI
//         child: Obx(() {
//           final unpaidCourses =
//               controller.courses.where((course) => course.status == "UNPAID").toList();

//           return RefreshIndicator(
//             onRefresh: () async {
//               await controller.fetchCourses(); // ✅ Refresh API call
//             },
//             child: unpaidCourses.isEmpty
//                ? Center(child: CircularProgressIndicator())
//                 : ListView.builder(
//                     physics: const AlwaysScrollableScrollPhysics(), // ✅ Enables scrolling even if list is short
//                     itemCount: unpaidCourses.length,
//                     itemBuilder: (context, index) {
//                       final course = unpaidCourses[index];
//                       return FreeCourseCard(course: course);
//                     },
//                   ),
//           );
//         }),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progenius/student/controller/course_controller/free_course/free_course_controller.dart';
import 'package:progenius/student/utils/appColors.dart';
import 'package:progenius/student/view/NavBarPages/Course_content/free_course/card.dart';
import 'package:progenius/widgets/dialogeUtils/dialogeUtils.dart';

class FreeContentPage extends StatelessWidget {
  final FreeCourseController controller = Get.put(FreeCourseController());

  FreeContentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Free Learning Content',
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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final unpaidCourses = 
              controller.courses.where((course) => course.status == "UNPAID").toList();

          if (unpaidCourses.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              DialogUtil.showErrorDialog(
                title: 'No Free Courses',
                message: 'There are currently no free courses available.',
                buttonText: 'Go Back',
                onPressed: () => Get.back(),
              );
            });
            
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 50, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No free courses available',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => controller.fetchCourses(),
                    child: const Text(
                      'Refresh',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await controller.fetchCourses();
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: unpaidCourses.length,
              itemBuilder: (context, index) {
                final course = unpaidCourses[index];
                return FreeCourseCard(course: course);
              },
            ),
          );
        }),
      ),
    );
  }
}