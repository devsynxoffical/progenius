import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialLinksPage extends StatelessWidget {
  // Function to open URLs
  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Gradient Header with Logo
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Gradient Header
              Container(
                width: Get.width,
                height: Get.height * 0.24,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.pink],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              // Positioned Logo (Overlapping the Gradient)
              Positioned(
                bottom: -50, // Adjust to overlap the header
                left: 0,
                right: 0,
                child: Center(
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: AssetImage('assets/logo1.png'), // Replace with your asset path
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 90), // Adjust to give space after logo
          
          // Title
          Text(
            'Pro Genius Students',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20),
          
          // Subtitle
          Text(
            'Follow Us',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          
          SizedBox(height: 20),
          
          // Social Media Icons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // YouTube
              IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.youtube,
                  color: Colors.red,
                  size: 30,
                ),
                onPressed: () {
                  _launchURL('https://youtube.com/@pgs?si=egn4Ce9CKjpwMdG4');
                },
              ),

              // Facebook
              IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.facebook,
                  color: Colors.blue,
                  size: 30,
                ),
                onPressed: () {
                  _launchURL('https://www.facebook.com/profile.php?id=100063903466573&mibextid=ZbWKwL');
                },
              ),

              // Instagram
              IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.instagram,
                  color: Colors.purple,
                  size: 30,
                ),
                onPressed: () {
                  _launchURL('https://www.instagram.com/pro_genius_students_?igsh=MW9wbjg3YXc0MHBtdA==');
                },
              ),

              // WhatsApp Channel
              IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.whatsapp,
                  color: Colors.green,
                  size: 30,
                ),
                onPressed: () {
                  _launchURL('https://whatsapp.com/channel/0029VagUrvYFCCoS68510V2o');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
