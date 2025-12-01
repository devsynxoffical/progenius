import 'package:flutter/material.dart';
import 'package:progenuisadmin/utils/app_colors/app_colors.dart';
import 'package:progenuisadmin/view/courses/free_course/free_cource.dart';
import 'package:progenuisadmin/view/courses/paid_course/paid/paid_course.dart';
import 'package:progenuisadmin/view/dashboard/dashboard.dart';
import 'package:progenuisadmin/view/profile/profile.dart';
import 'package:progenuisadmin/view/students_page/students.dart';



class MainNavigationPage extends StatefulWidget {
  @override
  _MainNavigationPageState createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  // List of pages for navigation
  final List<Widget> _pages = [
    DashboardView(),
   FreeCourseScreen(),
   PaidCourseScreen(),
   CustomerPage(),
   ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whitColor,
      body: _pages[_currentIndex], // Display the current page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the selected index
          });
        },
        items: [
          BottomNavigationBarItem(
            backgroundColor: AppColors.whitColor,
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            backgroundColor: AppColors.whitColor,
            icon: Icon(Icons.featured_play_list),
            label: 'Free Course',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.paid),
            label: 'Paid Course',
          ),
            BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Students',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
