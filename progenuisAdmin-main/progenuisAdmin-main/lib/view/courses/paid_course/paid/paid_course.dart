import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progenuisadmin/controllers/course_controller/paid_course/paid_course_controller.dart';
import 'package:progenuisadmin/model/course_model/course_model.dart';
import 'package:progenuisadmin/view/courses/free_course/course_card.dart';
import 'package:progenuisadmin/widgets/custome_button.dart';

class PaidCourseScreen extends StatelessWidget {
  final PaidCourseController _courseController = Get.put(PaidCourseController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: const Color.fromARGB(255, 243, 241, 241),
      appBar: AppBar(
        title: Text('Paid Content', style: TextStyle(color: Colors.white)),
         flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.pink],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),),
        actions: [
          IconButton(
            onPressed: () => showAddCourseDialog(context,_courseController),
            icon: Center(child: Icon(Icons.add, color: Colors.white, size: 25)),
          ),
            IconButton(
            onPressed: () {
              _courseController.isLoading(true);
               _courseController.fetchCourses();
            },
            icon: Center(child: Icon(Icons.refresh, color: Colors.white, size: 25)),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Obx(() { 
           if (_courseController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }
    return      RefreshIndicator(
          onRefresh: () async {
            await _courseController.fetchCourses();},
            child: ListView.builder(
                itemCount: _courseController.courses.length,
                itemBuilder: (context, index) {
                  final course = _courseController.courses[index];
                  return FreeCourseCard(
                    course: course,
                      callback: (){
                        _confirmDeleteLesson(course.id!);
                    },
                    );
                },
              ),
          );}),
      ),
    );
  }

  // Show confirmation dialog before deleting a lesson
void _confirmDeleteLesson(String courseId) {
  Get.dialog(
    AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Colors.white,
      contentPadding: EdgeInsets.all(24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Warning Icon
          Icon(
            Icons.warning_rounded,
            size: 48,
            color: Colors.orange,
          ),
          SizedBox(height: 16),
          // Title
          Text(
            'Delete Lesson',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          // Message
          Text(
            'Are you sure you want to delete this lesson? This action cannot be undone.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 24),
          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Cancel Button
              ElevatedButton(
                onPressed: () {
                  Get.back(); // Close the dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Delete Button
              ElevatedButton(
                onPressed: () {
                    _courseController.deleteCourse(courseId);
                  Get.back(); // Close the dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(
                  'Delete',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}



void showAddCourseDialog(BuildContext context, PaidCourseController courseController) {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  Rxn<File?> selectedImage = Rxn<File?>();
  final ImagePicker picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Check if the selected file is a JPEG or PNG
      String fileExtension = image.path.split('.').last.toLowerCase();
      if (fileExtension == 'jpg' || fileExtension == 'jpeg' || fileExtension == 'png') {
        selectedImage.value = File(image.path);
      } else {
        Get.snackbar("Invalid File", "Only JPEG and PNG files are allowed.");
      }
    }
  }

  Get.bottomSheet(
    Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Add New Course', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Divider(),
            Obx(() => GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                backgroundImage: selectedImage.value != null ? FileImage(selectedImage.value!) : null,
                child: selectedImage.value == null
                    ? Icon(Icons.image, size: 40, color: Colors.grey[600])
                    : null,
              ),
            )),
            SizedBox(height: 10),
            Text('Course Logo', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 10),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                labelText: 'Students',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Obx(() => courseController.isLoading.value
                ? CircularProgressIndicator() // Show loader
                : CustomButton(
                    text:  "Add Course",
                    onPressed: () async {
                      if (titleController.text.isEmpty ||
                          descriptionController.text.isEmpty ||
                          priceController.text.isEmpty) {
                        Get.snackbar("Error", "Please fill in all fields.");
                        return;
                      }

                      if (selectedImage.value == null) {
                        Get.snackbar("Error", "Please select an image.");
                        return;
                      }

                      final newCourse = FreeCourse(
                        title: titleController.text,
                        description: descriptionController.text,
                        status: 'PAID',
                      //  noOfStudents: double.parse(priceController.text),
                      );

                      // Start loading
                      await courseController.addCourse(newCourse, selectedImage.value!, "PAID");

                      // Close the dialog when done
                      if (!courseController.isLoading.value) ;
                       Navigator.pop(context);
                      
                    },
                   
                  ),
                  
                  ),
                  
          ],
        ),
      ),
    ),
    isScrollControlled: true,
  );
}

}
