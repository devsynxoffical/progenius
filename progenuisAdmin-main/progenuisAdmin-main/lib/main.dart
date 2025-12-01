import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progenuisadmin/controllers/course_controller/free_course/chapter_controller.dart';
import 'package:progenuisadmin/controllers/course_controller/free_course/free_course_controller.dart';
import 'package:progenuisadmin/controllers/course_controller/paid_course/paid_course_controller.dart';
import 'package:progenuisadmin/controllers/lesson_controller/lesson_controller.dart';
import 'package:progenuisadmin/controllers/login_controller/login_controller.dart';
import 'package:progenuisadmin/controllers/student_asign_course.dart';
import 'package:progenuisadmin/nav_bar.dart';
import 'package:progenuisadmin/utils/app_colors/app_colors.dart';
import 'package:progenuisadmin/utils/sharedprefrence.dart';
import 'package:progenuisadmin/view/auth/login/login.dart';
import 'package:progenuisadmin/view/splash_screen/splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());

    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<ChapterController>(() => ChapterController());
    Get.lazyPut<FreeCourseController>(() => FreeCourseController());
    Get.lazyPut<PaidCourseController>(() => PaidCourseController());
    Get.lazyPut<LessonController>(() => LessonController());
    Get.lazyPut<StudentCourseController>(() => StudentCourseController());
    
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pro Genius Admin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      home: SplashScreen(), // Show splash screen first
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 3)); // Show splash screen for 3 seconds

    String? token = await Sharedprefrence.getAccessToken();

    if (token != null) {
      Get.offAll(() => MainNavigationPage()); // Navigate to Main Page if token exists
      
    } else {
      Get.offAll(() => LoginPage()); // Otherwise, navigate to Login Page
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomSplashScreen(); // Display your custom splash screen
  }
}
