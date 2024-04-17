import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'LandingPage.dart';

Future<FirebaseApp> initializeFirebase() async {
  FirebaseApp firebaseApp = await Firebase.initializeApp();
  return firebaseApp;
}

void main() {
  initializeFirebase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // Show splash screen initially
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    // Wait for 3 seconds and then navigate to the landing page
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LandingPage()),
      );
    });

    // Display your splash screen UI
    return Scaffold(
      backgroundColor:
          Colors.transparent, // Set background color to transparent
      body: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset(
            'assets/background.svg', // Replace 'background.svg' with the path to your SVG file
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black
                .withOpacity(0.8), // Apply a semi-transparent black color
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: 5.0, sigmaY: 5.0), // Apply blur effect
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage('assets/logo.png'),
                      width: 80,
                      height: 80,
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Nextra',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
