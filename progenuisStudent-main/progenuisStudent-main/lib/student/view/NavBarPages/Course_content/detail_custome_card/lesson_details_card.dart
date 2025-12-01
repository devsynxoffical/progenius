
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progenius/student/view/video_player/video_plyer.dart';

class LessonDetailsCard extends StatelessWidget {
  final String chapterTitle;
  final Map<String, List<Map<String, String>>> lessonGroups; // Grouped lessons
  final bool isLocked;
  final VoidCallback onTap;

  LessonDetailsCard({
    required this.chapterTitle,
    required this.lessonGroups,
    required this.isLocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            chapterTitle,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 8),
        ...lessonGroups.entries.map((group) {
          return Card(
            color: Colors.white,
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Group title (e.g., Introduction, Summary)
                  Text(
                    group.key,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...group.value.map((lesson) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(255, 225, 226, 228),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: Icon(
                            lesson['type'] == 'video'
                                ? Icons.play_circle
                                : lesson['type'] == 'pdf'
                                    ? Icons.picture_as_pdf
                                    : Icons.quiz,
                            color: Colors.purple,
                          ),
                          title: Text(
                            lesson['title']!,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black87),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            if (lesson['type'] == 'video') {
                              // Navigate to the video player page
                              Get.to(() => VideoPlayerPage(
                                    videoUrl:
                                        "https://www.youtube.com/watch?v=tMeO9_MdfTo&list=RDTmRgK-pXH9c&index=6",
                                  ));
                            } else {
                              // Handle other lesson types (e.g., PDF or Quiz)
                              print('${lesson['title']} clicked!');
                            }
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
