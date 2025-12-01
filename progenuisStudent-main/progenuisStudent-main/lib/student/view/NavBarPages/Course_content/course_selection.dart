

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progenius/student/view/NavBarPages/Course_content/Student_enroled_course/student_enroled_course.dart';
import 'package:progenius/student/view/NavBarPages/Course_content/free_course/free_cources.dart';
import 'package:progenius/student/view/NavBarPages/Course_content/paid_course/paid_course.dart';

class CourseSelection extends StatefulWidget {
  @override
  _CourseSelectionState createState() => _CourseSelectionState();
}

class _CourseSelectionState extends State<CourseSelection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Gradient Header
          LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                width: constraints.maxWidth,
                height: Get.height * 0.24,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.pink],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Learning Content',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                // First Row with Free and Paid Content
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Free Content Container
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => FreeContentPage());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: Colors.blue,
                              width: 1.5,
                            ),
                          ),
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/fre.png', // Replace with your asset
                                height: 80,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Free Content',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    // Paid Content Container
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => PaidContentPage());
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: Colors.orange,
                              width: 1.5,
                            ),
                          ),
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/pad.png', // Replace with your asset
                                height: 80,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Paid Content',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Enrolled Content Container (Full width)
                GestureDetector(
                  onTap: () {
                   Get.to(() => StudentEnrolledCourse()); // Create this page
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: Colors.green,
                        width: 1.5,
                      ),
                    ),
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/enrld.png', // Replace with your asset
                          height: 80,
                         
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Enrolled Content',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}