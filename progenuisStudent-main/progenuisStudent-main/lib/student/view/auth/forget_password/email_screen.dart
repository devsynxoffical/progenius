

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progenius/student/controller/auth/forgot.dart';
import 'package:progenius/student/utils/appColors.dart';
import 'package:progenius/widgets/custome_textfield.dart';


class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});
  @override
  _EmailScreenState createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ForgotPasswordController _auth = Get.put(ForgotPasswordController());
    return Scaffold(
      backgroundColor: AppColors.whitColor,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        iconTheme: IconThemeData(color: AppColors.whitColor),
        title:
            Text('verification', style: TextStyle(color: AppColors.whitColor)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Center(
                    child: Image.asset('assets/logo1.png',
                        height: 90, width: 90)),
                SizedBox(height: 30),
                Text(
                  'Please Enter A Valid Email',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                  ),
                ),
                SizedBox(height: 20),
                const SizedBox(height: 5),
                CustomTextField(
                  hintText: 'Email',
                  controller: _auth.fogotEmailController,
                
                  prefixIcon: 
                    Icons.email,
                    
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: () async => _auth.sendOTP(),
                      child: _auth.isLoading.value
                          ? Center(
                              child: CupertinoActivityIndicator(
                              radius: 13,
                              color: Colors.white,
                            ))
                          : Text(
                              'verify',
                              style: TextStyle(color: AppColors.whitColor),
                            ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        textStyle: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                        backgroundColor: AppColors.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
