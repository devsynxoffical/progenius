
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progenuisadmin/controllers/lesson_controller/lesson_controller.dart';
import 'package:progenuisadmin/model/lesson_model/lesson_model.dart';
import 'package:progenuisadmin/utils/apiUrls.dart';
import 'package:progenuisadmin/utils/app_colors/app_colors.dart';
import 'package:progenuisadmin/view/courses/pdf_viewer/pdf.dart';
import 'package:progenuisadmin/view/courses/quiz_view/quiz_view.dart';
import 'package:progenuisadmin/view/courses/video_play/video_play.dart';
class LessonContentPage extends StatelessWidget {

  final LessonModel lesson;
  final LessonController controller = Get.put(LessonController());

  LessonContentPage({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F1F1),
 appBar: AppBar(
  title: Text(
    lesson.title ?? 'Lesson Details',
    style: TextStyle(color: AppColors.whitColor),
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
  elevation: 4,
  actions: [
    Wrap(
      spacing: -15, // Negative spacing reduces gaps
      children: [
        IconButton(
          icon: Icon(Icons.picture_as_pdf, size: 18),
          onPressed: () => _addContent(context, 'pdf'),
          padding: EdgeInsets.all(0), // Reduce padding
          constraints: BoxConstraints(), // Minimize button size
        ),
        IconButton(
          icon: Icon(Icons.video_library, size: 18),
          onPressed: () => _addContent(context, 'video'),
          padding: EdgeInsets.all(0),
          constraints: BoxConstraints(),
        ),
        IconButton(
          icon: Icon(Icons.quiz, size: 18),
          onPressed: () => _addContent(context, 'quiz'),
          padding: EdgeInsets.all(0),
          constraints: BoxConstraints(),
        ),
        IconButton(
          icon: Icon(Icons.refresh, size: 18),
          onPressed: () async {
            controller.isLoading(true);
            await controller.getAllChapterLesson(lesson.chapter!);
          },
          padding: EdgeInsets.all(0),
          constraints: BoxConstraints(),
        ),
      ],
    ),
  ],
),

      body: Obx((){
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }
          
      return  RefreshIndicator(
                onRefresh: () async {
            await controller.getAllChapterLesson(lesson.chapter!);
          },
           child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Video Lectures Section
                if (lesson.videos!.isNotEmpty)
                  _buildSection(
                    context,
                    title: 'Video Lectures',
                    icon: Icons.video_library,
                    items: lesson.videos!.map((video) {
                      return _buildCard(
                        context,
                        title: video['title'] ?? 'No Title',
                        icon: Icons.video_library,
                          iconButton: IconButton(
                            onPressed: () {
                              String contentId = video.containsKey("_id") ? video["_id"].toString() : video["id"].toString();
                              
                              print("Deleting Video ID: $contentId");

                              controller.deleteLessonContent(
                                lessonId: lesson.id!,
                                contentType: 'videos',
                                contentId: contentId,
                              );
                            },
                            icon: Icon(
                              Icons.delete,
                              size: 20,
                              color: Colors.red,
                            ),
                          ),

                        onTap: () {
                          print("-----------${video['url']}");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPlayerPage(videoUrl: video['url'] ?? ''),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                   
                // PDFs Section
                if (lesson.pdfs!.isNotEmpty)
                  _buildSection(
                    context,
                    title: 'PDF Notes',
                    icon: Icons.picture_as_pdf,
                    items: lesson.pdfs!.map((pdf) {
                      return _buildCard(
                        context,
                        title: pdf.title ?? 'Unnamed PDF',
                        icon: Icons.picture_as_pdf,
                        iconButton: IconButton(
                          onPressed: () {
                            // Call delete function from controller
                            _confirmDeleteLesson(lesson.id.toString(), pdf.id.toString());
                          },
                          icon: Icon(
                            Icons.delete,
                            size: 20,
                            color: Colors.red,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PdfViewerPage(
                                pdfUrl: "${ApiUrls.file}${pdf.destination}/${pdf.file}",
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                   
                // Quizzes Section
                if (lesson.quizes!.isNotEmpty)
                  _buildSection(
                    context,
                    title: 'Quizzes',
                    icon: Icons.quiz,
                    items: lesson.quizes!.map((quiz) {
                      return _buildCard(
                        context,
                        title: quiz['title'] ?? 'No Title',
                        icon: Icons.quiz,
                        iconButton: IconButton(
                            onPressed: () {
                              String contentId = quiz.containsKey("_id") ? quiz["_id"].toString() : quiz["id"].toString();
                              
                              print("Deleting Video ID: $contentId");

                              controller.deleteLessonContent(
                                lessonId: lesson.id!,
                                contentType: 'quizes',
                                contentId: contentId,
                              );
                            },
                            icon: Icon(
                              Icons.delete,
                              size: 20,
                              color: Colors.red,
                            ),
                          ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuizView(Url: quiz['url'] ?? ''),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
              ],
            ),
                   ),
         );}
      ),
    );
  }

  // Confirmation delete dialog
  void _confirmDeleteLesson(String lessonId, String pdfId) {
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
                    controller.deleteLessonPDF(
                      lessonId: lessonId,
                      pdfId: pdfId,
                    );
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

  // New method to handle PDF updates
  void _updatePDFs(BuildContext context) async {
    // Open a file picker to select new PDFs
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: true,
    );

    if (result != null) {
      List<File> pdfFiles = result.paths.map((path) => File(path!)).toList();

      // Call the updateLessonPDFs function
      controller.updateLessonPDFs(
        lessonId: lesson.id!,
        pdfFiles: pdfFiles,
      );
    } else {
      Get.snackbar("Info", "No PDFs selected", snackPosition: SnackPosition.TOP);
    }
  }

  // Build a section with a title and a list of items
  Widget _buildSection(BuildContext context,
      {required String title, required IconData icon, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.purple, size: 24),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
        ),
        // Section Content
        ...items,
      ],
    );
  }

  // Update the _addContent method
  void _addContent(BuildContext context, String type) {
    if (type == 'pdf') {
      _updatePDFs(context); // Call a new method to handle PDF updates
    } else {
      showDialog(
        context: context,
        builder: (context) => AddContentDialog(
          type: type,
          onSave: (newContent) {
            if (type == 'video') {
              List<Map<String, String>> updatedVideos = List<Map<String, String>>.from(lesson.videos!);
              updatedVideos.add(newContent);

              controller.updateLesson(
                lessonId: lesson.id!,
                title: lesson.title!,
                videos: updatedVideos,
                quizes: List<Map<String, String>>.from(lesson.quizes!),
              );
            } else if (type == 'quiz') {
              List<Map<String, String>> updatedQuizes = List<Map<String, String>>.from(lesson.quizes!);
              updatedQuizes.add(newContent);

              controller.updateLesson(
                lessonId: lesson.id!,
                title: lesson.title!,
                videos: List<Map<String, String>>.from(lesson.videos!),
                quizes: updatedQuizes,
              );
            }
          },
        ),
      );
    }
  }

  // Build a card for each item
  Widget _buildCard(BuildContext context,
      {required String title, required IconData icon, IconButton? iconButton, VoidCallback? onTap}) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      color: AppColors.whitColor,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        splashColor: Colors.purple.withOpacity(0.1),
        highlightColor: Colors.purple.withOpacity(0.05),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon with a gradient background
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.pink],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              SizedBox(width: 16), // Spacing between icon and text
              // Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4), // Spacing between title and subtitle
                    Text(
                      "Tap to view details",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              // Optional: Add an icon button if provided
              if (iconButton != null) iconButton,
            ],
          ),
        ),
      ),
    );
  }
}


class AddContentDialog extends StatefulWidget {
  final String type; // 'video' or 'quiz'
  final Function(Map<String, String>) onSave;

  AddContentDialog({required this.type, required this.onSave});

  @override
  _AddContentDialogState createState() => _AddContentDialogState();
}

class _AddContentDialogState extends State<AddContentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add ${widget.type}"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _urlController,
              decoration: InputDecoration(labelText: 'URL'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a URL';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newContent = {
                'title': _titleController.text,
                'url': _urlController.text,
              };
              widget.onSave(newContent);
              Navigator.pop(context);
            }
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}