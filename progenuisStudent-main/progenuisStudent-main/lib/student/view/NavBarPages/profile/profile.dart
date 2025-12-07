import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progenius/student/controller/auth/login.dart';
import 'package:progenius/student/controller/edit_profile/edit_profile.dart';
import 'package:progenius/student/utils/Api_Services/Urls.dart';
import 'package:progenius/student/utils/theme_controller.dart';
import 'package:progenius/student/view/NavBarPages/profile/edit_profile.dart';

class ProfilePage extends StatelessWidget {
  final EditProfileController controller = Get.put(EditProfileController());
  final LoginController _loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.pink],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Obx(() {
        final profile = controller.profile.value;

        return profile == null
            ? Center(child: CircularProgressIndicator()) // Show a loader while fetching data
            : Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.purple, Colors.pink],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -50,
                        left: 0,
                        right: 0,
                        child: Center(

                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.grey.shade200, // Optional: Adds a background color
                        child: ClipOval(
                          child: profile.profileImage != null && profile.profileImage!.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: '${ApiUrls.file}/${profile.destination}${profile.profileImage!}',
                                  placeholder: (context, url) => CircularProgressIndicator(), // Show loader while loading
                                  errorWidget: (context, url, error) => Image.asset('assets/logo1.png'), // Fallback on error
                                  fit: BoxFit.cover, // Ensures the image fits within the circle
                                  width: 140, // Ensures image size matches the CircleAvatar radius
                                  height: 140,
                                )
                              : Image.asset(
                                  'assets/logo1.png',
                                  fit: BoxFit.cover,
                                  width: 140,
                                  height: 140,
                                ),
                        ),
                      ),

                        ),
                      ),
                    ],
                  ),
                
                
                  SizedBox(height: 70),
                  // Name
                  Text(
                    profile.fullName ?? "N/A",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 5),
                  // Phone Number
                  Text(
                    profile.phoneNumber ?? "N/A",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 5),
                  // Email
                  Text(
                    profile.email ?? "N/A",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 30),
                  // Dark Mode Toggle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.dark_mode, color: Colors.grey[700]),
                              SizedBox(width: 12),
                              Text(
                                'Dark Mode',
                                style: TextStyle(fontSize: 16, color: Colors.black87),
                              ),
                            ],
                          ),
                          Obx(() {
                            final themeController = Get.find<ThemeController>();
                            return Switch(
                              value: themeController.isDarkMode.value,
                              onChanged: (value) => themeController.toggleTheme(),
                              activeColor: Colors.purple,
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  // Edit Profile Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => EditProfilePage());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide(color: Colors.grey),
                        ),
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Center(
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  // Logout Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle Logout Action
                        _loginController.logout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide(color: Colors.grey),
                        ),
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Center(
                        child: Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
      }),
    );
  }
}
