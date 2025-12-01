// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progenius/student/model/course_model/chapter_model.dart';
import 'package:progenius/student/utils/appColors.dart';
import 'package:progenius/student/view/NavBarPages/Course_content/lesson_page.dart';

class ChapterCard extends StatelessWidget {
  final Chapter chapter;

  const ChapterCard({
    Key? key,
    required this.chapter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: InkWell(
        onTap: () => Get.to(() => LessonDetailsPage(chapterId: chapter.id!)),
        borderRadius: BorderRadius.circular(12),
        splashColor: AppColors.secondary.withOpacity(0.2), // ✅ Ripple effect
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          color: Colors.white,
          shadowColor: Colors.black12,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
            child: Row(
              children: [
                // Folder Icon
                Container(
                padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.folder, color: Colors.purple, size: 32),
                ),
                const SizedBox(width: 16),

                // Chapter Title & Description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chapter.title ?? "No Title",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        chapter.description ?? "No description available",
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.black54,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),

                // Arrow Icon
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: AppColors.secondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

