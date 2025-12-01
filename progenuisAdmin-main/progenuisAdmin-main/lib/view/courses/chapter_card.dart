import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progenuisadmin/model/course_model/chapter_model.dart';
import 'package:progenuisadmin/view/courses/lesson_page.dart';

class ChapterCard extends StatelessWidget {
  final Chapter chapter;
  final VoidCallback onToggleLock;
   final VoidCallback onDelete;

  const ChapterCard({
    Key? key,
    required this.chapter,
    required this.onToggleLock,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
       
        child: InkWell(
          onTap: () {
            Get.to(()=>LessonDetailsPage(chapterId: chapter.id!,));
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Icon(Icons.folder, color: Colors.purple, size: 30),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chapter.title ?? "No Title",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          chapter.description ?? "No Description",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 10 ,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(onPressed: onDelete, icon: Icon(Icons.delete,color: Colors.red,size: 18,)),
             ElevatedButton(
                  onPressed: onToggleLock,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (chapter.isLocked ?? false) ? Colors.grey : Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // ✅ Smaller border radius
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2), // ✅ Minimal padding
                    minimumSize: Size(60, 25), // ✅ Defined size (width x height)
                  ),
                  child: Text(
                    (chapter.isLocked ?? false) ? "Locked" : "Allow",
                    style: TextStyle(color: Colors.white, fontSize: 9), // ✅ Smaller font
                  ),
                )

                ],
              ),
            ),
          ),
        ),
      );
    
  }

  
}



