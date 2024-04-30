import 'dart:convert';
import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:nextra/DeveloperProfile.dart';
import 'package:nextra/HelpScreen.dart';
import 'package:nextra/NetworkSpeedTestScreen.dart';
import 'package:nextra/OcrScreen.dart';
import 'package:nextra/QrScanner.dart';
import 'package:nextra/TalkToBot.dart';
import 'package:nextra/TranslationScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LoginScreen.dart';
import 'PrivacyPolicy.dart';
import 'TermsCondition.dart';
import 'UserProfile.dart';

final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
final FirebaseAnalyticsObserver observer =
    FirebaseAnalyticsObserver(analytics: analytics);

// Sign out method
Future<void> _signOut(BuildContext context) async {
  // Clear authentication token
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('idToken');
  // Clear other user-related data if needed
  prefs.remove('userId');
  // Navigate back to login screen
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => LoginScreen()),
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// Home Screen
class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String email = '';
  Future<String?> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userId');
    final String databaseUrl =
        'https://nextra-71204-default-rtdb.asia-southeast1.firebasedatabase.app/users/$userId.json';

    try {
      final response = await http.get(Uri.parse(databaseUrl));

      if (response.statusCode == 200) {
        final userData = json.decode(response.body) as Map<String, dynamic>;
        final userKey = userData.keys.first;
        final user = userData[userKey];

        setState(() {
          email = user['email'] ?? '';
        });
        return email;
      } else {
        print('Failed to fetch user data');
        return null;
      }
    } catch (error) {
      print('Error: $error');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 0, 0, 1),
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // Add a menu icon
        leading: IconButton(
          icon: const Icon(Icons.menu),
          color: Colors.white,
          onPressed: () {
            // Get the ScaffoldState for the current context
            _scaffoldKey.currentState?.openDrawer();
            _fetchUserData();
          },
        ),

        // Add user icon
        actions: <Widget>[
          IconButton(
            onPressed: () {
              //navigate to UserProfile
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfile()),
              );
            },
            icon: const Icon(Icons.person),
            color: Colors.white,
          ),
        ],
      ),

      // Added a Drawer Navigation widget
      drawer: Drawer(
        backgroundColor: Colors.transparent,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            color: const Color.fromARGB(1, 90, 43, 113).withOpacity(0.5),
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color:
                        const Color.fromARGB(1, 90, 43, 113).withOpacity(0.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Card(
                              margin: const EdgeInsets.only(right: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(80),
                              ),
                              color: Colors.transparent,
                              child: Image.asset(
                                'assets/logo.png',
                                width: 60,
                                height: 60,
                              ),
                            ),
                            Text(
                              'Nextra',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ]),
                      Text(
                        email,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home_outlined,
                      color: Colors.white, size: 30),
                  title: const Text('Home',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  onTap: () {
                    // Add functionality for Home
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.document_scanner_outlined,
                      color: Colors.white, size: 30),
                  title: const Text('OCR',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  onTap: () {
                    // navigate to OCR screen
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const OcrScreen(),
                    ));
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.translate,
                      color: Colors.white, size: 30),
                  title: const Text('Translation',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  onTap: () {
                    //navigate to translation screen
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const TranslationScreen(),
                    ));
                  },
                ),

                ListTile(
                  leading:
                      const Icon(Icons.speed, color: Colors.white, size: 30),
                  title: const Text('Network Speed Test',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  onTap: () {
                    //navigate to Network Speed Test
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const NetworkSpeedTest(),
                    ));
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.qr_code_scanner,
                      color: Colors.white, size: 30),
                  title: const Text('QR Scanner',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  onTap: () {
                    //navigate to QR Scanner
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const QRScannerScreen(),
                    ));
                  },
                ),

                const SizedBox(
                  height: 290,
                ),

                const ListTile(
                  title: Text('More',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  //Disable click
                  enabled: false,
                ),
                //bottom navigation section in drawer menu
                SizedBox(
                  width: double.maxFinite,
                  height: 56,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Card(
                          color: Colors.black26,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            onPressed: () {
                              //move to terms and conditions screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TermsCondition(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.text_snippet_outlined,
                              color: Colors.white,
                            ),
                          )),
                      Card(
                        color: Colors.black26,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          onPressed: () {
                            //move to privacy policy screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PrivacyPolicy(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.privacy_tip_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      //Developer button
                      Card(
                        color: Colors.black26,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          onPressed: () {
                            //Navigate to Developer Screen
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const DeveloperProfileScreen(),
                            ));
                          },
                          icon: const Icon(
                            Icons.developer_mode_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      //customer support
                      Card(
                          color: Colors.black26,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            onPressed: () {
                              //move to customer support screen
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HelpScreen(),
                                  ));
                            },
                            icon: const Icon(
                              Icons.support_agent_outlined,
                              color: Colors.white,
                            ),
                          )),

                      //logout
                      Card(
                        color: Colors.black26,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          onPressed: () {
                            //exit from application
                            _signOut(context);
                          },
                          icon: const Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Add more list tiles for other drawer items as needed
              ],
            ),
          ),
        ),
      ),

//Drawer navigation complete

      // Body of the Home screen
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
                  color:
                      Colors.black.withOpacity(0.8), // Adjust opacity as needed
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
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
//scrollable container
            child: SingleChildScrollView(
//make it scrollable
              scrollDirection: Axis.vertical,
// set the background color: rgba(32, 29, 43, 1)
              child: Column(
//make it scrollable
                mainAxisSize: MainAxisSize.min,
                children: [
//section 1 container
                  Container(
                    width: double.maxFinite,
                    height: 220,
                    margin: const EdgeInsets.fromLTRB(5, 20, 5, 30),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        child: Card(
                            color: const Color.fromRGBO(32, 29, 43, 1),
                            margin: const EdgeInsets.all(10),
                            child: Column(children: [
                              Column(children: [
                                Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  child: Text(
                                    "${greeting()}\n\nHow I can help you today?",
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ])
                            ]))),
                  ),

//section 2 container
                  Container(
                      color: Colors.transparent,
//width according to the screen size
                      width: MediaQuery.of(context).size.width,
                      height: 250,
                      margin: const EdgeInsets.all(5),
//create a container for the customized buttons using Card & clickable
                      child: Row(children: [
                        Card(
                            color: Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
//make it clickable
                                InkWell(
                                  onTap: () {
// Show an Alert Dialog
// Navigate to the TalkToBot screen
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const TalkToBot(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2.1,
//align texts in left
                                    alignment: Alignment.centerLeft,

                                    child: Card(
                                      color: const Color.fromARGB(
                                          250, 198, 244, 50),
                                      child: Column(
                                        children: [
                                          Column(children: [
                                            Row(children: [
                                              Card(
                                                color: const Color.fromARGB(
                                                    20, 0, 0, 0),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(
                                                      8.0), // Adjust the padding as needed

                                                  child: Image(
                                                    image: AssetImage(
                                                        'assets/taliboot.png'),
                                                    width: 30,
                                                    height: 30,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 67,
                                              ),
                                              const Image(
                                                image: AssetImage(
                                                  'assets/arrow.png',
                                                ),
                                                width: 40,
                                                height: 40,
                                              ),
                                            ])
                                          ]),
                                          const SizedBox(height: 82),
                                          Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2,
                                              height: 80,
                                              margin: const EdgeInsets.fromLTRB(
                                                  10, 0, 0, 4),
                                              child: const Text(
                                                "Talk\nto Bot",
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

//button 1 completed

//button 2 started
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.1,
                                  color: Colors.transparent,
                                  child: Column(children: [
                                    SizedBox(
                                        width: double.maxFinite,
                                        height: 120,
//making it clickable
                                        child: InkWell(
                                          onTap: () {
// Show an Alert Dialog
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    "Chat with Bot",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  content: const Text(
                                                      "This is the content of the dialog."),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(); // Close the dialog
                                                      },
                                                      child:
                                                          const Text('Close'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                          child: Card(
                                            color: Colors.deepPurpleAccent,
                                            margin: const EdgeInsets.fromLTRB(
                                                5, 5, 5, 5),
                                            child: Column(children: [
                                              Column(children: [
                                                Row(children: [
                                                  Card(
                                                    color: const Color.fromARGB(
                                                        20, 0, 0, 0),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: const Padding(
                                                      padding: EdgeInsets.all(
                                                          8.0), // Adjust the padding as needed

                                                      child: Image(
                                                        image: AssetImage(
                                                            'assets/chatIcon.png'),
                                                        width: 30,
                                                        height: 30,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 83,
                                                  ),
                                                  const Image(
                                                    image: AssetImage(
                                                      'assets/arrow.png',
                                                    ),
                                                    width: 40,
                                                    height: 40,
                                                  ),
                                                ])
                                              ]),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              const Text(
                                                "Chat with bot",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ]),
                                          ),
                                        )),
//button 3
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.1,
                                        height: 120,
//making it clickable
                                        child: InkWell(
                                          onTap: () {
// Show an Alert Dialog
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    "Search with Image",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  content: const Text(
                                                      "This is the content of the dialog."),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(); // Close the dialog
                                                      },
                                                      child:
                                                          const Text('Close'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
//add contents
                                          child: Card(
//button 3
                                            color: const Color.fromARGB(
                                                250, 254, 196, 221),
                                            child: Column(children: [
                                              Column(children: [
                                                SizedBox(
                                                    width: double.maxFinite,
                                                    child: Row(children: [
//add margin between icons
                                                      const SizedBox(
                                                        width: 5,
                                                      ),

                                                      Card(
                                                        color: const Color
                                                            .fromARGB(
                                                            20, 0, 0, 0),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                        ),
                                                        child: const Padding(
                                                          padding: EdgeInsets.all(
                                                              8.0), // Adjust the padding as needed

                                                          child: Image(
                                                            image: AssetImage(
                                                                'assets/img.png'),
                                                            width: 30,
                                                            height: 30,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 80,
                                                      ),

                                                      const Image(
                                                        image: AssetImage(
                                                          'assets/arrow.png',
                                                        ),
                                                        width: 40,
                                                        height: 40,
                                                      ),
                                                    ])),
                                              ]),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              const Text("Search with Image",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                            ]),
                                          ),
                                        ))
                                  ]),
                                ), //button 3 completed
                              ],
                            )),
                      ])),

//section 3 container for horizontal cards contains
                  Container()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning 🌄';
    }
    if (hour < 17) {
      return 'Good Afternoon 🕛';
    }
    return 'Good Evening 🌃';
  }
}
