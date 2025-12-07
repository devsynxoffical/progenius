import 'package:flutter/material.dart';
import 'package:progenius/student/model/lesson_model/lesson_model.dart';
import 'package:progenius/student/utils/Api_Services/Urls.dart';
import 'package:progenius/student/utils/appColors.dart';
import 'package:progenius/student/view/pdf_view/pdf_view.dart';
import 'package:progenius/student/view/qiuz_view/quiz_view.dart';
import 'package:progenius/student/view/video_player/video_plyer.dart';

class LessonContentPage extends StatelessWidget {
  final LessonModel lesson;

  LessonContentPage({required this.lesson});

  @override
  Widget build(BuildContext context) {
    // Save PDF URLs, Video URLs, and Quiz Data in separate variables
    List<String> pdfUrls = [];
    List<String> videoLinks = [];
    List<String> quizLinks = [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          lesson.title ?? 'Lesson Details',
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
          ),),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Lectures Section
            if (lesson.videos!.isNotEmpty)
              SectionTitle(title: 'Video Lectures'),
            ...lesson.videos!.map((video) {
              String videoTitle = video['title'] ?? 'No Title';
              String videoUrl = video['url'] ?? '';

              // Save video URL
              videoLinks.add(videoUrl);

              return _buildCard(
                context,
                title: "Video: $videoTitle",
                icon: Icons.video_library,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerPage(videoUrl: videoUrl),
                    ),
                  );
                },
              );
            }).toList(),

            // PDFs Section
            if (lesson.pdfs!.isNotEmpty)
              SectionTitle(title: 'PDF Notes'),
            ...lesson.pdfs!.map((pdf) {
              String pdfUrl = "${ApiUrls.file}/${pdf.destination}/${pdf.file}";

              // Save PDF URL
              pdfUrls.add(pdfUrl);

              return _buildCard(
                context,
                title: "${pdf.title}",
              
                icon: Icons.picture_as_pdf,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PdfViewerPage(pdfUrl: pdfUrl),
                    ),
                  );
                },
              );
            }).toList(),

            // Quizzes Section
            if (lesson.quizes!.isNotEmpty)
              SectionTitle(title: 'Quizzes'),
            ...lesson.quizes!.map((quiz) {
              String quizUrl = quiz['url'] ?? '';
              String quizTitle = quiz['title'] ?? 'No Title';
              quizLinks.add(quizUrl);
              return _buildCard(
                context,
                title: "$quizTitle",
                icon: Icons.quiz,
              onTap:   (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizView(Url: quizUrl),
                    ),
                  );
              }
              );
            }).toList(),

         
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required String title, required IconData icon, VoidCallback? onTap}) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Icon(icon, color: Colors.purple),
        title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        onTap: onTap,
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple),
      ),
    );
  }
}
