import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:progenuisadmin/controllers/fogot_controller/fogot.dart';
import 'package:progenuisadmin/view/auth/login/login.dart';
import 'package:progenuisadmin/widgets/custome_button.dart';
import 'package:progenuisadmin/widgets/custome_textfield.dart';



class ForgotPasswordPage extends StatelessWidget {
  final ForgotPasswordController forgotPasswordController =
      Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
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
            // Bottom Wave
            Align(
              alignment: Alignment.bottomRight,
              child: SvgPicture.asset(
                'assets/splashBtm.svg',
                fit: BoxFit.cover,
              ),
            ),
            // Forgot Password Content
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
                    SizedBox(height: 30),
                    // Title
                    Text(
                      'Forgot Password',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Description is a placeholder text commonly used to demonstrate the visual.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 40),
                    // Email TextField
                    Obx(() => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              hintText: 'E-mail',
                              controller:
                                  forgotPasswordController.emailController,
                              prefixIcon: Icons.email,
                            ),
                            if (forgotPasswordController.emailError.value
                                .isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  forgotPasswordController.emailError.value,
                                  style:
                                      TextStyle(color: Colors.red, fontSize: 12),
                                ),
                              ),
                          ],
                        )),
                    SizedBox(height: 30),
                    // Forgot Password Button
                    Obx(() => CustomButton(
                          text: 'Forgot Password',
                          isLoading: forgotPasswordController.isLoading.value,
                          onPressed: forgotPasswordController.submitForgotPassword,
                        )),
                    SizedBox(height: 20),
                    // Navigate to Login Page
                    InkWell(
                      onTap: () => Get.to(()=>LoginPage()),
                      child: Text.rich(
                        TextSpan(
                          text: "Already have an account? ",
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                          children: [
                            TextSpan(
                              text: 'Sign in',
                              style: TextStyle(
                                  color: Colors.purple,
                                  fontWeight: FontWeight.w500),
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
