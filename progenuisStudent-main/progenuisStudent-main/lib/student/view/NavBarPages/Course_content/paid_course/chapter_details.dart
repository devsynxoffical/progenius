
import 'package:flutter/material.dart';
import 'package:progenius/student/view/NavBarPages/Course_content/detail_custome_card/lesson_details_card.dart';
import 'package:progenius/student/utils/appColors.dart';

class ChapterDetailPage extends StatelessWidget {
  final String chapterTitle;
  final Map<String, List<Map<String, String>>> lessons;


  ChapterDetailPage({
    required this.chapterTitle,
    required this.lessons,
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 236, 236),
      appBar: AppBar(
        title: Text(
          chapterTitle,
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
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: AppColors.whitColor),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          LessonDetailsCard(
            chapterTitle: chapterTitle,
            lessonGroups: lessons,
            isLocked: false,
            onTap: () {
          
            },
          ),
        ],
      ),
    );
  }



}
