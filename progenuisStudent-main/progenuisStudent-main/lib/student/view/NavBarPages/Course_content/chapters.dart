import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progenius/student/controller/course_controller/free_course/chapter_controller.dart';
import 'package:progenius/student/controller/edit_profile/edit_profile.dart';
import 'package:progenius/student/utils/Api_Services/Urls.dart';
import 'package:progenius/student/view/NavBarPages/Course_content/chapter_card.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChapterScreen extends StatelessWidget {
  final ChapterController chapterController = Get.put(ChapterController());
  final profile = Get.put(EditProfileController());
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
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
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
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: "${ApiUrls.file}/$destination/$courseImage",
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
                    ),
                  ),
                  SizedBox(width: 16),
                  
                  /// 🔹 Text with MaxLines = 2
                  Expanded(
                    child: Text(
                      courseTitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2, // Restrict to 2 lines
                      overflow: TextOverflow.ellipsis, // Show ... if it overflows
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
                      );
                    },
                  )),
          ),
        ],
      ),
    );
  }
}
