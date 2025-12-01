import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:progenuisadmin/controllers/login_controller/login_controller.dart';
import 'package:progenuisadmin/utils/all_texts.dart';
import 'package:progenuisadmin/view/auth/fogot/forgot.dart';
import 'package:progenuisadmin/widgets/custome_button.dart';
import 'package:progenuisadmin/widgets/custome_textfield.dart';


class LoginPage extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        // Prevent the layout from resizing when the keyboard appears
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            // Top Wave (Static Background)
            Align(
              alignment: Alignment.topCenter,
              child: SvgPicture.asset(
                'assets/splashTop.svg',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            // Bottom Wave (Static Background)
            Align(
              alignment: Alignment.bottomLeft,
              child: SvgPicture.asset(
                'assets/splashBtm.svg',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            // Login Content
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 90),
                child: Column(
                  children: [
                    // Logo
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/logo1.png'),
                    ),
                    SizedBox(height: 20),
                    Text(
                      AllTexts.Signintoyouraccount,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    // Email TextField
                    Obx(() => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              hintText: 'E-mail',
                              controller: loginController.emailController,
                              prefixIcon: Icons.email,
                            ),
                            if (loginController.emailError.value.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  loginController.emailError.value,
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
                              controller: loginController.passwordController,
                              isPassword: !loginController.isPasswordVisible.value,
                              prefixIcon: Icons.lock,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  loginController.isPasswordVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  loginController.togglePasswordVisibility();
                                },
                              ),
                            ),
                            if (loginController.passwordError.value.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  loginController.passwordError.value,
                                  style: TextStyle(color: Colors.red, fontSize: 12),
                                ),
                              ),
                          ],
                        )),
                    SizedBox(height: 10),
                    // InkWell(
                    //  onTap: () => Get.to(ForgotPasswordPage()),
                    //   child: Align(
                    //     alignment: Alignment.centerRight,
                    //     child: Padding(
                    //       padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    //       child: Text(
                    //         AllTexts.fogotpass,
                    //         style: TextStyle(color: Colors.grey, fontSize: 14),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: 30),
                    // Login Button
                    Obx(() => CustomButton(
                          text: 'Login',
                          isLoading: loginController.isLoading.value,
                          onPressed: () {
                            loginController.login();
                          },
                        )),

                              SizedBox(height: 20),
              
                
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
