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
  const MyApp({super.key,});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // Show splash screen initially
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

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


//
// import 'dart:async';
// import 'dart:ui';
//
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'LandingPage.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
//
// Future<FirebaseApp> initializeFirebase() async {
//   FirebaseApp firebaseApp = await Firebase.initializeApp();
//   return firebaseApp;
// }
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await initializeFirebase();
//   await MobileAds.instance.initialize();
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: SplashScreen(), // Show splash screen initially
//     );
//   }
// }
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   InterstitialAd? _interstitialAd;
//   bool _isAdLoaded = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadInterstitialAd();
//
//     // Set a timeout to navigate to the landing page if the ad does not load within 5 seconds
//     Future.delayed(const Duration(seconds: 5), () {
//       if (!_isAdLoaded) {
//         _navigateToLandingPage();
//       }
//     });
//   }
//
//   String getAdUnitId() {
//     if (defaultTargetPlatform == TargetPlatform.android) {
//       return 'ca-app-pub-6636793314590394~1256012702'; // Replace with your Android Ad Unit ID
//     } else if (defaultTargetPlatform == TargetPlatform.iOS) {
//       return 'ca-app-pub-6636793314590394~2842774159'; // Replace with your iOS Ad Unit ID
//     } else {
//       throw UnsupportedError('Unsupported platform');
//     }
//   }
//
//   void _loadInterstitialAd() {
//     InterstitialAd.load(
//       adUnitId: getAdUnitId(),
//       request: const AdRequest(),
//       adLoadCallback: InterstitialAdLoadCallback(
//         onAdLoaded: (InterstitialAd ad) {
//           _interstitialAd = ad;
//           _isAdLoaded = true;
//           _showAd();
//         },
//         onAdFailedToLoad: (LoadAdError error) {
//           print('InterstitialAd failed to load: $error');
//           _navigateToLandingPage();
//         },
//       ),
//     );
//   }
//
//   void _showAd() {
//     if (_isAdLoaded) {
//       _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
//         onAdDismissedFullScreenContent: (InterstitialAd ad) {
//           ad.dispose();
//           _navigateToLandingPage();
//         },
//         onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
//           ad.dispose();
//           _navigateToLandingPage();
//         },
//       );
//       _interstitialAd!.show();
//     } else {
//       _navigateToLandingPage();
//     }
//   }
//
//   void _navigateToLandingPage() {
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(builder: (context) => const LandingPage()),
//     );
//   }
//
//   @override
//   void dispose() {
//     _interstitialAd?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           SvgPicture.asset(
//             'assets/background.svg',
//             fit: BoxFit.cover,
//           ),
//           Container(
//             color: Colors.black.withOpacity(0.8),
//             child: BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
//               child: const Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Image(
//                       image: AssetImage('assets/logo.png'),
//                       width: 80,
//                       height: 80,
//                     ),
//                     SizedBox(height: 20.0),
//                     Text(
//                       'Nextra',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 24.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
