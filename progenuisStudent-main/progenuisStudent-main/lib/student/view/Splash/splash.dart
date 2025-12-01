
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomSplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Top SVG
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SvgPicture.asset(
                'assets/splashTop.svg',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            // Center Logo
            Center(
              child: CircleAvatar(
               // backgroundColor: Colors.white,
                radius: 80,
                child: Image.asset(
                  'assets/logo1.png',
                  fit: BoxFit.contain,
                )
              ),
            ),
            // Bottom SVG
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SvgPicture.asset(
                'assets/splashBtm.svg',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


