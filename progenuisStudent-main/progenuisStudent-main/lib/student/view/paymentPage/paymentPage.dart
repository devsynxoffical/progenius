// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progenius/navBar.dart';
import 'package:progenius/student/utils/appColors.dart';
import 'package:flutter/services.dart';
import 'package:progenius/widgets/custome_button.dart';

class PaymentDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Payment Details",
          style: TextStyle(color: AppColors.whitColor, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: AppColors.whitColor),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.pink],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 4,
        shadowColor: Colors.black54,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          color: AppColors.whitColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 10,
          shadowColor: Colors.grey.withOpacity(0.5),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset("assets/logo1.png", width: 100, height: 100),
                ),
                SizedBox(height: 20),

                // Payment Details
                Text(
                  "Easypaisa & Jazzcash",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.secondary),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  "Account Title: Waqas Asghar",
                  style: TextStyle(fontSize: 18, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: "03056306559"));
                    Get.snackbar("Copied", "Phone number copied to clipboard", backgroundColor: AppColors.secondary, colorText: Colors.white);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.redAccent, width: 1.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "03056306559",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.redAccent),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.copy, size: 20, color: Colors.redAccent),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),

                Text(
                  "After payment, send the payment screenshot to:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: "03119921467"));
                    Get.snackbar("Copied", "Admin contact copied to clipboard", backgroundColor: AppColors.secondary, colorText: Colors.white);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blueAccent, width: 1.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "03334694332 ",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.copy, size: 20, color: Colors.blueAccent),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),

                // Close Button
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(text: "Close", onPressed: (){
                    Get.to(() => MainNavigationPage());
                
                  })
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
