import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:progenius/student/controller/auth/signUp.dart';
import 'package:progenius/student/view/auth/login/login.dart';
import 'package:progenius/widgets/custome_button.dart';
import 'package:progenius/widgets/custome_textfield.dart';

class SignUpPage extends StatelessWidget {
  final SigupController _signupController = Get.put(SigupController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Top Wave
            Align(
              alignment: Alignment.topCenter,
              child: SvgPicture.asset(
                'assets/splashTop.svg',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          
            // Sign-Up Content
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 80),
                child: Column(
                  children: [
                         // Back Button
                    Align(
                      alignment: Alignment.topLeft,
                      child: TextButton(
                        onPressed: () => Get.to(LoginPage()),
                        child: Text(
                          'Back',
                          style: TextStyle(color: Colors.purple, fontSize: 16),
                        ),
                      ),
                    ),
                    // Logo
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/logo1.png'),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Sign Up to your account',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    // Full Name TextField
                    Obx(() => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              hintText: 'Full Name',
                              controller: _signupController.nameController,
                              prefixIcon: Icons.person,
                            ),
                            if (_signupController.nameError.value.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  _signupController.nameError.value,
                                  style: TextStyle(color: Colors.red, fontSize: 12),
                                ),
                              ),
                          ],
                        )),
                    SizedBox(height: 20),
                    // Email TextField
                    Obx(() => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              hintText: 'E-mail',
                              controller: _signupController.emailController,
                              prefixIcon: Icons.email,
                            ),
                            if (_signupController.emailError.value.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  _signupController.emailError.value,
                                  style: TextStyle(color: Colors.red, fontSize: 12),
                                ),
                              ),
                          ],
                        )),
                    SizedBox(height: 20),
                    // Phone TextField
                    Obx(() => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              hintText: 'Phone',
                              controller: _signupController.phoneController,
                              prefixIcon: Icons.phone,
                            ),
                            if (_signupController.phoneError.value.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  _signupController.phoneError.value,
                                  style: TextStyle(color: Colors.red, fontSize: 12),
                                ),
                              ),
                          ],
                        )),
                    SizedBox(height: 20),
                    // Password TextField with Visibility Toggle
                    Obx(() => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              hintText: 'Password',
                              controller: _signupController.passwordController,
                              isPassword: !_signupController.isPasswordVisible.value,
                              prefixIcon: Icons.lock,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _signupController.isPasswordVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  _signupController.togglePasswordVisibility();
                                },
                              ),
                            ),
                            if (_signupController.passwordError.value.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  _signupController.passwordError.value,
                                  style: TextStyle(color: Colors.red, fontSize: 12),
                                ),
                              ),
                          ],
                        )),
                    SizedBox(height: 30),
                    // Register Button
                  Obx(() => CustomButton(
                    text: 'Register',
                    isLoading: _signupController.isLoading.value,
                    onPressed: () async {
                      await _signupController.register(); // Await function call
                    },
                  )),

                    SizedBox(height: 20),
                    // Navigate to Login Page
                    InkWell(
                      onTap: () => Get.to(LoginPage()),
                      child: Text.rich(
                        TextSpan(
                          text: "Already have an account? ",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                          children: [
                            TextSpan(
                              text: 'Login',
                              style: TextStyle(color: Colors.purple, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
