
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progenius/student/controller/auth/forgot.dart';
import 'package:progenius/student/utils/appColors.dart';


class OtpVerificationPage extends StatelessWidget {
  final String email;

  final ForgotPasswordController controller = Get.find();

  OtpVerificationPage({required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.whitColor),
        title: Text(
          'Verify OTP',
          style: TextStyle(
              color: AppColors.whitColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor:
            AppColors.secondary, // Use primary theme color if defined
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Otp Verification',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary, // Theme color
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Enter The OTP Sent To $email',
                style: TextStyle(fontSize: 16, color: AppColors.greyColor),
                textAlign: TextAlign.center,
              ),
              SizedBox(height:40),
              TextField(
                controller: controller.otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  labelText: 'OTP',
                  hintText: 'Six Digit Code',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  counterText: '',
                ),
                style: TextStyle(fontSize: 18, letterSpacing: 2.0),
              ),
              SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: Obx(()=>
                  ElevatedButton(
                    onPressed: () async => await controller.verifyOTP(),
                    child: 
                    controller.isLoading.value
                          ? Center(
                              child: CupertinoActivityIndicator(
                              radius: 13,
                              color: Colors.white,
                            ))
                   : Text(
                      'Verify OTP',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.whitColor),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      backgroundColor: AppColors.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
              // SizedBox(height: 20),
              // TextButton(
              //   onPressed: () async => await controller.resendOTP(),
              //   child: Text(
              //     'Resend OTP',
              //     style: TextStyle(
              //       color: AppColors.primary,
              //       fontSize: 16,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
