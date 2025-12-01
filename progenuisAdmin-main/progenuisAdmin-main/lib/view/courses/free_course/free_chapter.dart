import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:progenuisadmin/controllers/course_controller/free_course/chapter_controller.dart';
import 'package:progenuisadmin/model/course_model/chapter_model.dart';
import 'package:progenuisadmin/utils/apiUrls.dart';
import 'package:progenuisadmin/utils/app_colors/app_colors.dart';
import 'package:progenuisadmin/view/courses/chapter_card.dart';
class ChapterScreen extends StatelessWidget {
  final ChapterController chapterController = Get.put(ChapterController());
  final String courseId;
  final String courseTitle;
  final String courseImage;
  final String destination;
 
  ChapterScreen({
    required this.courseId,
    required this.courseTitle,
    required this.courseImage,
    required this.destination,
    
  });
  @override
  Widget build(BuildContext context) {
    chapterController.fetchChapters(courseId);

    return Scaffold(
      backgroundColor: Color(0xFFF3F1F1),
      appBar: AppBar(
        title: Text('Chapters', style: TextStyle(color: Colors.white)),
          flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.pink],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () => showAddChapterDialog(context, chapterController, courseId),
            icon: Icon(Icons.add, color: Colors.white, size: 25),
          ),
        ],
      ),
      body: Column(
        children: [
          /// 🔹 Course Info Card
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
              colors: [Colors.purple, Colors.pink],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
      
              ),
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: CachedNetworkImage(
                      imageUrl: "${ApiUrls.file}/$destination/$courseImage",
                      width: 70,
                      height: 70,
                      fit: BoxFit.fill,
                      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(courseTitle, style: TextStyle(color: Colors.white, 
                        fontSize: 16, fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text("Unlimited Chapters ",
                            style: TextStyle(color: Colors.white70, fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

    

          SizedBox(height: 10),

          /// 🔹 Chapters List
Expanded(
  child: Obx(() => chapterController.isLoading.value
      ? Center(child: CircularProgressIndicator())
      : ListView.builder(
          itemCount: chapterController.filteredChapters.length,
          itemBuilder: (context, index) {
            final chapter = chapterController.filteredChapters[index];
            return ChapterCard(
              chapter: chapter,
              onToggleLock: () {
                chapterController.toggleLock(chapter);
              },
              onDelete: () {
                _confirmDeleteLesson(chapter.id!);
              
              },
            );
          },
        )),
),
       
        ],
      ),
    );


  }

// Show confirmation dialog before deleting a lesson
void _confirmDeleteLesson(String chapterId) {
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
                  chapterController.deleteChapter(chapterId);
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


void showAddChapterDialog(BuildContext context, ChapterController chapterController, String courseId) {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  RxBool isLocked = false.obs;

  Get.defaultDialog(
    title: "Add New Chapter",
    titleStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: AppColors.primary,
    ),
    content: Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title Field
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: "Title",
              prefixIcon: Icon(Icons.title, color: AppColors.primary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.primary),
              ),
            ),
          ),
          SizedBox(height: 16),

          // Description Field
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(
              labelText: "Description",
              prefixIcon: Icon(Icons.description, color: AppColors.primary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.primary),
              ),
            ),
          ),
          SizedBox(height: 16),

          // Lock Chapter Checkbox
          Obx(
            () => Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: CheckboxListTile(
                title: Text(
                  "Lock Chapter",
                  style: TextStyle(color: AppColors.primary,fontSize: 12),
                ),
                value: isLocked.value,
                onChanged: (val) => isLocked.value = val ?? false,
                activeColor: AppColors.primary,
                secondary: Icon(
                  isLocked.value ? Icons.lock : Icons.lock_open,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),

          // Add Chapter Button
          CustomButton1(
            text: "Add Chapter",
            onPressed: () {
              chapterController.addChapter(
                Chapter(
                  title: titleController.text,
                  description: descriptionController.text,
                  isLocked: isLocked.value,
                  courseId: courseId,
                ),
                courseId,
              );
              Get.back();
            },
          ),
        ],
      ),
    ),
    backgroundColor: AppColors.whitColor,
    radius: 15,
  );
}
}


class CustomButton1 extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  CustomButton1({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.whitColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
