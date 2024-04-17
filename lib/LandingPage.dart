import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nextra/LoginScreen.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key});

  @override
  Widget build(BuildContext context) {
    changeStatusBarColor();
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          backgroundColor: Color.fromRGBO(0, 0, 0, 1),
          body: Stack(
            fit: StackFit.expand,
            children: [
              // Background SVG with black overlay
              Positioned.fill(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    SvgPicture.asset(
                      'assets/background.svg', // Replace 'background.svg' with the path to your SVG file
                      fit: BoxFit.cover,
                    ),
                    Container(
                      color: Colors.black
                          .withOpacity(0.8), // Adjust opacity as needed
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                            sigmaX: 6.0,
                            sigmaY: 6.0), // Adjust blur intensity as needed
                        child: Container(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Container(
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Add your content here
                    const SizedBox(height: 40),
                    const Image(
                      image: AssetImage('assets/logo.png'),
                      width: 150,
                      height: 150,
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                    const Text(
                      'Welcome to Nextra',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the home screen
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
                        foregroundColor: const Color.fromRGBO(32, 29, 43, 1),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 70, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          color: Color.fromRGBO(32, 29, 43, 1),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  //change the color of Statusbar icons
  changeStatusBarColor() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }
}
