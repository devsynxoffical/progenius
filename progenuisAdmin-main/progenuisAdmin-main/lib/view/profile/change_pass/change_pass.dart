import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progenuisadmin/nav_bar.dart';
import 'package:progenuisadmin/widgets/custome_button.dart';
import 'package:progenuisadmin/widgets/custome_textfield.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final oldPass = TextEditingController();
  final newPass = TextEditingController();
  final confimPass = TextEditingController();

  bool _isOldPassVisible = false;
  bool _isNewPassVisible = false;
  bool _isConfirmPassVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.to(() => MainNavigationPage()),
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
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gradient Header with Profile Picture
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
                  bottom: -40,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: GestureDetector(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 70,
                            backgroundImage:
                                AssetImage('assets/logo1.png'), // Replace with your asset
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 90),
            // Old Password Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomTextField(
                    hintText: "Old Password",
                    prefixIcon: Icons.lock,
                    controller: oldPass,
                    obscureText: !_isOldPassVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isOldPassVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isOldPassVisible = !_isOldPassVisible;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // New Password Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    hintText: "New Password",
                    prefixIcon: Icons.lock,
                    controller: newPass,
                    obscureText: !_isNewPassVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isNewPassVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isNewPassVisible = !_isNewPassVisible;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Confirm Password Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    hintText: "Confirm Password",
                    prefixIcon: Icons.lock,
                    controller: confimPass,
                    obscureText: !_isConfirmPassVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPassVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPassVisible = !_isConfirmPassVisible;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Update Button with Loading State
            Center(
              child: CustomButton(
                text: 'Update',
                onPressed: () {
                  // Handle update password logic
                },
              ),
            ),
            const SizedBox(height: 20), // Add some space at the bottom
          ],
        ),
      ),
    );
  }
}
