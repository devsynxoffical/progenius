
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progenius/student/controller/lesson_controller/lesson_controller.dart';
import 'package:progenius/student/utils/appColors.dart';
import 'package:progenius/student/view/NavBarPages/Course_content/lesson_details_page.dart';

class LessonDetailsPage extends StatelessWidget {
  final String chapterId;
  final LessonController lessonController = Get.put(LessonController());

  LessonDetailsPage({required this.chapterId}) {
    lessonController.getAllChapterLesson(chapterId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lessons', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.whitColor)),
        iconTheme: IconThemeData(color: AppColors.whitColor),
          flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.pink],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),),
     
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
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    spacing: 5,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.auto_stories_sharp,color: AppColors.secondary,),
                      Text(
                        
                        '| ${lesson.title }',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.secondary),
                      ),
                    
            
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }




}

