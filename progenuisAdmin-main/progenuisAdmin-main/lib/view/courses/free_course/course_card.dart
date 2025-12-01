
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progenuisadmin/controllers/course_controller/free_course/free_course_controller.dart';
import 'package:progenuisadmin/controllers/course_controller/free_course/update_free_course.dart';
import 'package:progenuisadmin/controllers/course_controller/paid_course/paid_course_controller.dart';
import 'package:progenuisadmin/controllers/student_asign_course.dart';
import 'package:progenuisadmin/model/course_model/course_model.dart';
import 'package:progenuisadmin/utils/apiUrls.dart';
import 'package:progenuisadmin/utils/app_colors/app_colors.dart';
import 'package:progenuisadmin/view/courses/free_course/free_chapter.dart';

class FreeCourseCard extends StatelessWidget {
  final FreeCourse? course;
  final VoidCallback? callback;
  final StudentCourseController courseController = Get.put(StudentCourseController());
  final UpdateCourseController updateCourseController = Get.put(UpdateCourseController());
  final PaidCourseController paidCourseController = Get.put(PaidCourseController());
  final FreeCourseController freeCourseController = Get.put(FreeCourseController());

  FreeCourseCard({required this.course, required this.callback, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => ChapterScreen(
            courseId: course?.id ?? '',
            courseImage: course?.courseImage ?? '',
            courseTitle: course?.title ?? '',
            destination: course?.destination ?? '',
          )),
      child: Card(
        color: AppColors.whitColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: _buildCourseImage(),
          title: Text(
            course?.title ?? "No Title",
            style: const TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            ' Students: ${course?.students?.length ?? 0}',
            style: const TextStyle(fontSize: 10),
            overflow: TextOverflow.ellipsis,
          ),
          trailing: _buildPopupMenu(context), // ✅ Three-dot menu button
        ),
      ),
    );
  }

  /// **Popup Menu for Options**
  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: Colors.grey), // ✅ Three-dot icon
      onSelected: (value) {
        if (value == 'edit') {
          _updateCourseTitle(context, course!.id!, course!.status!);
        } else if (value == 'delete') {
          if (callback != null) callback!();
        } else if (value == 'view_students') {
          if (course?.status == 'PAID') {
            _showStudentListDialog(
              context,
              course!.id!,
              course!.students?.map((student) => student.id ?? "").toList() ?? [],
            );
          }
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: const [
              Icon(Icons.edit, color: Colors.grey, size: 18),
              SizedBox(width: 8),
              Text("Edit Title"),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: const [
              Icon(Icons.delete, color: Colors.red, size: 18),
              SizedBox(width: 8),
              Text("Delete Course"),
            ],
          ),
        ),
        if (course?.status == 'PAID') // ✅ Show only for paid courses
          PopupMenuItem(
            value: 'view_students',
            child: Row(
              children: const [
                Icon(Icons.people, color: Colors.blue, size: 18),
                SizedBox(width: 8),
                Text("View Students"),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCourseImage() {
    if (course?.courseImage != null &&
        course!.courseImage!.isNotEmpty &&
        course?.destination != null &&
        course!.destination!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: CachedNetworkImage(
          imageUrl: "${ApiUrls.file}/${course!.destination}/${course!.courseImage}",
          width: 55,
          height: 55,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(
            Icons.image_not_supported,
            size: 40,
            color: Colors.grey,
          ),
        ),
      );
    }
    return const Icon(Icons.image_not_supported, size: 50, color: Colors.grey);
  }

void _showStudentListDialog(BuildContext context, String courseId, List<String> assignedStudents) {
  final TextEditingController searchController = TextEditingController();
  final PaidCourseController _paidController = Get.put(PaidCourseController());

  final RxString searchQuery = ''.obs;
  final RxList<String> localSelectedStudents = RxList<String>.from(assignedStudents);
  final RxBool isSaving = false.obs; // ✅ To show progress when saving

  Get.dialog(
    Dialog(
      backgroundColor: const Color.fromARGB(255, 237, 237, 238),
      insetPadding: EdgeInsets.only(left: 10,right: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.7, // ✅ Fixed Height
        child: Column(
          children: [
            // ✅ Title
            Text(
              'Assign Course',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 10),

            // ✅ Search Bar
            TextField(
              controller: searchController,
              onChanged: (value) => searchQuery.value = value.toLowerCase(),
              decoration: InputDecoration(
                hintText: 'Search Students By Email...',
                prefixIcon: Icon(Icons.search, color: Colors.grey, size: 15),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
              ),
            ),
            const SizedBox(height: 10),

            // ✅ Scrollable List (Expanded to avoid button movement)
            Expanded(
              child: Obx(() {
                if (courseController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                var filteredUsers = courseController.allUsers
                    .where((user) => user['email']!.toLowerCase().contains(searchQuery.value))
                    .toList();

                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    var user = filteredUsers[index];
                    bool isPreviouslyAssigned = assignedStudents.contains(user['id']);

                    return SizedBox(
                      height: Get.height*.1,
                      child: Card(
                        color: AppColors.whitColor,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                        child: Obx(() => CheckboxListTile(
                          title: Text(
                            user['name'] ?? "Unknown",
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            user['email'] ?? "Unknown",
                            style: TextStyle(fontSize: 8, fontWeight: FontWeight.w500),
                          ),
                          value: localSelectedStudents.contains(user['id']),
                          onChanged: (bool? value) {
                            if (value == true) {
                              localSelectedStudents.add(user['id']!);
                            } else {
                              localSelectedStudents.removeWhere((id) => id == user['id']);
                            }
                            localSelectedStudents.refresh(); // ✅ Ensure UI updates
                          },
                          activeColor: AppColors.primary,
                          controlAffinity: ListTileControlAffinity.leading,
                          secondary: isPreviouslyAssigned
                              ? Icon(Icons.check_circle, color: Colors.green, size: 15)
                              : null,
                        )),
                      ),
                    );
                  },
                );
              }),
            ),

            // ✅ Fixed Buttons at Bottom
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Cancel Button
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(fontSize: 14, color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),

                  // Save Button
                  Obx(() => ElevatedButton(
                        onPressed: () async {
                          isSaving.value = true; // ✅ Show Progress Indicator
                          courseController.selectedStudents.value = List<String>.from(localSelectedStudents);
                          await courseController.updateStudentsInCourse(courseId);
                          isSaving.value = false; // ✅ Hide Progress Indicator
                          Get.back(); // ✅ Close Dialog
                         // courseController.fetchAllUsers(); // ✅ Refresh data instantly
                         // _paidController.fetchCourses();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: isSaving.value
                            ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white))
                            : Text(
                                'Save Selection',
                                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: false, // Prevent accidental closing
  );


}



void _updateCourseTitle(BuildContext context, String courseId, String status) {
  TextEditingController titleController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Text(
            "Update Course Title",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),

          // Form Input
          Form(
            key: _formKey,
            child: TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Enter new title",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Title cannot be empty";
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 20),

          // Buttons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Cancel Button
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => Get.back(),
                  child: Text("Cancel"),
                ),
              ),
              SizedBox(width: 10),

              // Update Button
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // ✅ Show loading dialog
                      Get.dialog(
                        Center(child: CircularProgressIndicator()),
                        barrierDismissible: false,
                      );

                      // ✅ Update course title
                      await updateCourseController.updateCourseTitle(courseId, titleController.text, status);

                      // ✅ Fetch updated courses
                      if (status == "UNPAID") {
                        await freeCourseController.fetchCourses();
                      } else {
                        await paidCourseController.fetchCourses();
                      }

                      // ✅ Close loading dialog
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }

                      // ✅ Close bottom sheet
                      Get.back();

                   
                   }
                  },
                  child: Text("Update", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    isScrollControlled: true,
  );
}

}