import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progenuisadmin/controllers/login_controller/login_controller.dart';
import 'package:progenuisadmin/controllers/profile/profile.dart';

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

        return  Column(
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
                            backgroundImage: profile!.profileImage != null &&
                                    profile.profileImage!.isNotEmpty
                                ? NetworkImage(profile.profileImage!)
                                : AssetImage('assets/logo1.png') as ImageProvider,
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
                  // Edit Profile Button
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       Get.to(() => EditProfilePage());
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Colors.white,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(30.0),
                  //         side: BorderSide(color: Colors.grey),
                  //       ),
                  //       elevation: 0,
                  //       padding: EdgeInsets.symmetric(vertical: 15),
                  //     ),
                  //     child: Center(
                  //       child: Text(
                  //         'Edit Profile',
                  //         style: TextStyle(
                  //           color: Colors.black87,
                  //           fontSize: 16,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 15),
                  // Logout Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle Logout Action
                        _loginController.isLoading;
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
