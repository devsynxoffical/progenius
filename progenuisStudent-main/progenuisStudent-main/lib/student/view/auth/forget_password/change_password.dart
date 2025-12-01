import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progenius/student/controller/auth/forgot.dart';
import 'package:progenius/student/utils/appColors.dart';
import 'package:progenius/widgets/custome_textfield.dart';


class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final ForgotPasswordController authController = Get.put(ForgotPasswordController());
 // bool _isPasswordVisible = false;
 // bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whitColor,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        iconTheme: IconThemeData(color: AppColors.whitColor),
        title: Text('Reset Password',
            style: TextStyle(color: AppColors.whitColor)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 80),
                Center(
                    child: Image.asset('assets/logo1.png',
                        height: 90, width: 90)),
                SizedBox(height: 30),

                Text(
                  'password',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackColor,
                  ),
                ),
                const SizedBox(height: 5),

                CustomTextField(
                  hintText: 'Enter Password',
                  controller: authController.passwordController,
                 
                  
                  prefixIcon:  Icons.lock, 
                  // suffixIcon: IconButton(
                  //   icon: Icon(
                  //     _isPasswordVisible
                  //         ? Icons.visibility
                  //         : Icons.visibility_off,
                  //     color: AppColors.secondary,
                  //   ),
                  //   onPressed: () {
                  //     setState(() {
                  //       _isPasswordVisible = !_isPasswordVisible;
                  //     });
                  //   },
                  // ),
                  // validator: (value) {
                  //   // Check if the password is empty
                  //   if (value == null || value.isEmpty) {
                  //     return AppLocalizations.of(context)!.pleaseEnterYourPassword;
                  //   }

                  //   if (value.length < 8 || value.length > 15) {
                  //     return AppLocalizations.of(context)!.passwordMustBeBetweenAndCharactersLong;
                  //   }

                  //   if (!RegExp(r'[A-Z]').hasMatch(value)) {
                  //     return AppLocalizations.of(context)!.passwordMustIncludeAtLeastUppercaseLetter;
                  //   }

                  //   if (!RegExp(r'[0-9]').hasMatch(value)) {
                  //     return AppLocalizations.of(context)!.passwordMustIncludeAtLeastNumber;
                  //   }

                  //   return null;
                  // },
                ),

                const SizedBox(height: 15),
                // Password Input
                Text(
                  'Confirm Password',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackColor,
                  ),
                ),
                SizedBox(height: 8),
                CustomTextField(
                  hintText: 'Enter Confirm Password',
                 
                  controller: authController.confirmPasswordController,
                 
                  prefixIcon: Icons.lock,
                  // suffixIcon: IconButton(
                  //   icon: Icon(
                  //     _isConfirmPasswordVisible
                  //         ? Icons.visibility
                  //         : Icons.visibility_off,
                  //     color: AppColors.secondary,
                  //   ),
                  //   onPressed: () {
                  //     setState(() {
                  //       _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  //     });
                  //   },
                  // ),
                  // validator: (value) {
                  //   // Check if the password is empty
                  //   if (value == null || value.isEmpty) {
                  //     return AppLocalizations.of(context)!.pleaseEnterYourPassword;
                  //   }

                  //   if (value.length < 8 || value.length > 15) {
                  //     return AppLocalizations.of(context)!.passwordMustBeBetweenAndCharactersLong;
                  //   }

                  //   if (!RegExp(r'[A-Z]').hasMatch(value)) {
                  //     return AppLocalizations.of(context)!.passwordMustIncludeAtLeastUppercaseLetter;
                  //   }

                  //   if (!RegExp(r'[0-9]').hasMatch(value)) {
                  //     return AppLocalizations.of(context)!.passwordMustIncludeAtLeastNumber;
                  //   }

                  //   return null;
                  // },
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Obx(() => ElevatedButton(
                        onPressed: authController.isLoading.value
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  await authController.resetPassword();
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: authController.isLoading.value
                            ? CircularProgressIndicator(
                                color: AppColors.whitColor)
                            : Text(
                                'update',
                                style: TextStyle(
                                    fontSize: 16, color: AppColors.whitColor),
                              ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
