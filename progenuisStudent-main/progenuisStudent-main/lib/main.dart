import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:progenius/student/view/onboarding_screen/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progenius/navBar.dart';
import 'package:progenius/student/controller/auth/login.dart';
import 'package:progenius/student/controller/course_controller/free_course/chapter_controller.dart';
import 'package:progenius/student/controller/course_controller/free_course/free_course_controller.dart';
import 'package:progenius/student/controller/course_controller/paid_course/paid_course_controller.dart';
import 'package:progenius/student/controller/lesson_controller/lesson_controller.dart';
import 'package:progenius/student/utils/appColors.dart';
import 'package:progenius/student/utils/theme_controller.dart';
import 'package:progenius/student/utils/sharedPrefrense/sharedprefrence.dart';
import 'package:progenius/student/view/auth/login/login.dart';
import 'package:progenius/student/view/Splash/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize GetStorage for offline caching
  await GetStorage.init();
  
  // Initialize Firebase (optional - comment out if google-services.json not available)
  try {
    await Firebase.initializeApp();
    
    // Pass all uncaught errors to Crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  } catch (e) {
    print('Firebase initialization failed: $e');
    // Continue without Firebase if not configured
  }
  
  // Initialize controllers before app starts
  Get.put(ThemeController());
  Get.put(LoginController());
  Get.put(ChapterController());
  Get.put(FreeCourseController());
  Get.put(PaidCourseController());
  Get.put(LessonController());
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pro Genius',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeController.themeMode,
      home: SplashScreen(),
    ));
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
  try {
    await Future.delayed(Duration(seconds: 3));
    
    final prefs = await SharedPreferences.getInstance();
    final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
    final String? token = await Sharedprefrence.getAccessToken();

    Widget nextScreen;
    if (isFirstTime) {
      await prefs.setBool('isFirstTime', false);
      nextScreen = OnboardingScreen();
    } else if (token != null) {
      nextScreen = MainNavigationPage();
    } else {
      nextScreen = LoginPage();
    }
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => nextScreen),
      );
    }
  } catch (e) {
    // Fallback to login screen if something goes wrong
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => LoginPage()),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return CustomSplashScreen(); // Your existing splash screen
  }
}

