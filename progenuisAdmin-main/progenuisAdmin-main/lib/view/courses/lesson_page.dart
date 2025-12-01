
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progenuisadmin/controllers/lesson_controller/lesson_controller.dart';
import 'package:progenuisadmin/utils/app_colors/app_colors.dart';
import 'package:progenuisadmin/view/courses/lesson_details_page.dart';



class LessonDetailsPage extends StatelessWidget {
  final String chapterId;
  final LessonController lessonController = Get.put(LessonController());

  LessonDetailsPage({required this.chapterId}) {
    lessonController.getAllChapterLesson(chapterId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F1F1),
      appBar: AppBar(
        title: Text(
          'Lessons',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.whitColor),
        ),
        iconTheme: IconThemeData(color: AppColors.whitColor),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.pink],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => showAddLessonDialog(context, chapterId),
            icon: Icon(Icons.add, size: 28),
          ),
        ],
      ),
      body: Obx(() {
        if (lessonController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: lessonController.lessons.length,
          itemBuilder: (context, index) {
            final lesson = lessonController.lessons[index];
            return InkWell(
              onTap: () {
                // Navigate to LessonContentPage with the selected lesson
                Get.to(() => LessonContentPage(lesson: lesson));
              },
            child: Card(
              color: AppColors.whitColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)), // ✅ Reduced border radius
              elevation: 3, // ✅ Slightly lower elevation for a flatter look
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4), // ✅ Reduced margins
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10), // ✅ Compact padding
                leading: const Icon(Icons.auto_stories_sharp, color: Colors.purple, size: 22), // ✅ Smaller Icon
                title: Text(
                  lesson.title ?? 'No Title',
                  style: const TextStyle(
                    fontSize: 14, // ✅ Smaller font for compact design
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  onPressed: () => _confirmDeleteLesson(lesson.id!),
                  icon: const Icon(Icons.delete, color: Colors.red, size: 18), // ✅ Reduced size
                ),
              ),
            ),

            );
          },
        );
      }),
    );
  }

// Show confirmation dialog before deleting a lesson
void _confirmDeleteLesson(String lessonId) {
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
                  lessonController.deleteLesson(lessonId);
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

void showAddLessonDialog(BuildContext context, String chapterId) {
  TextEditingController titleController = TextEditingController();
  RxList<Map<String, String>> videos = <Map<String, String>>[].obs;
  RxList<Map<String, String>> quizes = <Map<String, String>>[].obs;
  RxList<File> pdfFiles = <File>[].obs;

  Get.dialog(
    AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text('Add Lesson', textAlign: TextAlign.center, 
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: AppColors.primary)),
      content: SingleChildScrollView(
        child: Column(
          spacing: 5,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Lesson Title
            TextField(controller: titleController, 
            decoration: InputDecoration(

              labelText: 'Lesson Title')),

            // Add Videos Section
            // SectionTitle(title: 'Videos'),
            
            Obx(() => Column(
                  children: [
                    ...videos.map((video) => Card(
                      child: ListTile(
                            title: Text(video['title'] ?? 'No Title'),
                            subtitle: Text(video['url'] ?? 'No URL'),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => videos.remove(video),
                            ),
                          ),
                    )),
                 SizedBox(
                  width: double.infinity,
                   child: ElevatedButton(
                    
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary, // Set the primary color for the button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Set radius to 10
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Add padding for better touch area
                    ),
                    onPressed: () => showAddVideoDialog(videos),
                    child: Text(
                      'Add Video',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.whitColor, // Optional: adjust the font size for better readability
                        fontWeight: FontWeight.bold, // Optional: make the text bold
                      ),
                    ),
                                   ),
                 ),

                  ],
                )),

            // Add Quizzes Section
           // SectionTitle(title: 'Quizzes'),
           Divider(),
            Obx(() => Column(
                  children: [
                    ...quizes.map((quiz) => Card(
                       
                      child: ListTile(
                            title: Text(quiz['title'] ?? 'No Title'),
                            subtitle: Text(quiz['url'] ?? 'No URL'),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => quizes.remove(quiz),
                            ),
                          ),
                    )),
                    SizedBox(
                        width: double.infinity,
                      child: ElevatedButton(
                         style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary, // Set the primary color for the button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Set radius to 10
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Add padding for better touch area
                                        ),
                        onPressed: () => showAddQuizDialog(quizes),
                        child: Text('Add Quiz',
                        style: TextStyle(
                        fontSize: 16,
                        color: AppColors.whitColor, // Optional: adjust the font size for better readability
                        fontWeight: FontWeight.bold, // Optional: make the text bold
                      ),),
                      ),
                    ),
                  ],
                )),

            // Add PDFs Section
          //  SectionTitle(title: 'PDFs'),
          Divider(),
            Obx(() => Column(
                  children: [
                    ...pdfFiles.map((file) => Card(
                      child: ListTile(
                            title: Text(file.path.split('/').last),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => pdfFiles.remove(file),
                            ),
                          ),
                    )),
                    SizedBox(
                        width: double.infinity,
                      child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary, // Set the primary color for the button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Set radius to 10
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Add padding for better touch area
                                        ),
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
                          if (result != null && result.files.isNotEmpty) {
                            pdfFiles.add(File(result.files.single.path!));
                          }
                        },
                        child: Text('Add PDF',
                        style: TextStyle(
                        fontSize: 16,
                        color: AppColors.whitColor, // Optional: adjust the font size for better readability
                        fontWeight: FontWeight.bold, // Optional: make the text bold
                      ),),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            lessonController.addLesson(
              chapterId: chapterId,
              title: titleController.text,
              videos: videos.toList(),
              quizes: quizes.toList(),
              pdfFiles: pdfFiles.toList(),
            );
            Get.back();
          },
          child: Text('Add Lesson'),
        ),
      ],
    ),
  );
}

// Helper function to show a dialog for adding a video
void showAddVideoDialog(RxList<Map<String, String>> videos) {
  TextEditingController titleController = TextEditingController();
  TextEditingController urlController = TextEditingController();

  Get.dialog(
    AlertDialog(
      title: Text('Add Video'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: titleController, decoration: InputDecoration(labelText: 'Video Title')),
          TextField(controller: urlController, decoration: InputDecoration(labelText: 'Video URL')),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            videos.add({
              'title': titleController.text,
              'url': urlController.text,
            });
            Get.back();
          },
          child: Text('Add'),
        ),
      ],
    ),
  );
}

// Helper function to show a dialog for adding a quiz
void showAddQuizDialog(RxList<Map<String, String>> quizes) {
  TextEditingController titleController = TextEditingController();
  TextEditingController urlController = TextEditingController();

  Get.dialog(
    AlertDialog(
      title: Text('Add Quiz'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: titleController, decoration: InputDecoration(labelText: 'Quiz Title')),
          TextField(controller: urlController, decoration: InputDecoration(labelText: 'Quiz URL')),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            quizes.add({
              'title': titleController.text,
              'url': urlController.text,
            });
            Get.back();
          },
          child: Text('Add'),
        ),
      ],
    ),
  );
}
}

// Helper widget for section titles
class SectionTitle extends StatelessWidget {
  final String title;

  SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
      ),
    );
  }
}