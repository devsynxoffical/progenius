import 'package:flutter/material.dart';
import 'package:progenius/student/view/NavBarPages/Course_content/course_selection.dart';
import 'package:progenius/student/view/NavBarPages/profile/profile.dart';
import 'package:progenius/student/view/NavBarPages/progenuisSocial/social.dart';



class MainNavigationPage extends StatefulWidget {
  @override
  _MainNavigationPageState createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  // List of pages for navigation
  final List<Widget> _pages = [
  //  DashboardView(),
    CourseSelection(),
    SocialLinksPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Display the current page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the selected index
          });
        },
        items: [
          //  BottomNavigationBarItem(
          //   icon: Icon(Icons.dashboard),
          //   label: 'Dashboard',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Course',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/logo1.png',height: 30,width: 30,),
            label: 'PGS',
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
