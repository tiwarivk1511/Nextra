import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperProfileScreen extends StatefulWidget {
  const DeveloperProfileScreen({super.key});

  @override
  _DeveloperProfileScreenState createState() => _DeveloperProfileScreenState();
}

class _DeveloperProfileScreenState extends State<DeveloperProfileScreen> {
  final DateTime _startDate = DateTime(2023, 1, 1); // Example start date

  String calculateExperience() {
    final DateTime currentDate = DateTime.now();
    final int totalMonths = ((currentDate.year - _startDate.year) * 12) +
        currentDate.month -
        _startDate.month;

    final int years = totalMonths ~/ 12;
    final int months = totalMonths % 12;

    return '$years years ${months > 0 ? '$months months' : ''}';
  }

  @override
  Widget build(BuildContext context) {
    final String experience = calculateExperience();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Developer Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background SVG
          SvgPicture.asset(
            'assets/background.svg', // Replace with your SVG file path
            fit: BoxFit.cover,
          ),
          // Blur effect container
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withOpacity(0.3),
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const CircleAvatar(
                      radius: 50,
                      // current company
                      backgroundImage: NetworkImage(
                          'https://media.licdn.com/dms/image/D4D03AQFHzBtz16_10w/profile-displayphoto-shrink_800_800/0/1691164256762?e=1724284800&v=beta&t=RasNkzlrcA5QAV1QaTUJZ9MpTdYAs7e3ish6q9ioJxQ'),
                    ),

                    const SizedBox(height: 20),
                    // Developer Name
                    const Text(
                      'Vikash Tiwari',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Developer Bio
                    const Text(
                      'Software Developer',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Other Details
                    const Card(
                      elevation: 5,
                      color: Colors.blueGrey,
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Location:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Noida, Uttar Pradesh, India 🇮🇳',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      elevation: 5,
                      color: Colors.blueGrey,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Experience:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              experience,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Skills:',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Technology cards
                    const Row(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          // current company
                          backgroundImage: NetworkImage(
                              'https://th.bing.com/th/id/OIP.17DpGFS55XPqjLrO8-B3BwHaGl?rs=1&pid=ImgDetMain'),
                        ),
                        SizedBox(width: 10),
                        CircleAvatar(
                          radius: 50,
                          // previous company
                          backgroundImage: NetworkImage(
                              'https://i0.wp.com/www.electrumitsolutions.com/wp-content/uploads/2021/01/FlutterCover.jpg?fit=1024%2C576&ssl=1'),
                        ),
                        SizedBox(width: 10),
                        CircleAvatar(
                          radius: 50,
                          // Replace with your profile image link
                          backgroundImage: NetworkImage(
                              'https://media.licdn.com/dms/image/C510BAQGyCfCQzGP_RA/company-logo_200_200/0/1631355717831?e=1720656000&v=beta&t=aBC4zhwJTEPVpDCnjHwDEdY0UC5rz4iXbgSRFZzNf2I'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Worked With:',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // Companies cards
                    const Row(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          // Replace with your profile image link
                          backgroundImage: NetworkImage(
                              'https://media.licdn.com/dms/image/D4D0BAQEIVHdYdc7DEQ/company-logo_200_200/0/1695624268577/brancosoft_logo?e=1720656000&v=beta&t=EhvtYyhoCyO_UlpjK7czNwmx18aBRNpyrC04xwa9OQ8'),
                        ),
                        SizedBox(width: 10),
                        CircleAvatar(
                          radius: 50,
                          // Replace with your profile image link
                          backgroundImage: NetworkImage(
                              'https://media.licdn.com/dms/image/C4D0BAQGJSjZEvNP5Pg/company-logo_200_200/0/1660715797715/assertit_logo?e=1720656000&v=beta&t=GHDmA5N6_kwTjjHWBVLCnyMDSRsagOK6p4aRpcmhOCA'),
                        ),
                        SizedBox(width: 10),
                        CircleAvatar(
                          radius: 50,
                          // Replace with your profile image link
                          backgroundImage: NetworkImage(
                              'https://media.licdn.com/dms/image/C4E0BAQGDUXp8h14OJg/company-logo_200_200/0/1630622610595/ipemgroup_logo?e=1720656000&v=beta&t=CGyke-Uy_lER8wxLrCI3mlNKSmmpeJjEvwUPHtFREkw'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Contact with Developer:',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    // Social Media Buttons
                    Card(
                        elevation: 5,
                        color: Colors.blueGrey,
                        margin: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton.icon(
                                  icon: const FaIcon(FontAwesomeIcons.linkedin,
                                      color: Colors.white),
                                  onPressed: () {
                                    launch(
                                        'https://in.linkedin.com/in/vikash-tiwari15112000');
                                  },
                                  label: const Text(
                                    'LinkedIn',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  icon: const FaIcon(FontAwesomeIcons.instagram,
                                      color: Colors.white),
                                  onPressed: () {
                                    launch(
                                        'https://www.instagram.com/tiwari_vk15/');
                                  },
                                  label: const Text(
                                    'Instagram',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.pink,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton.icon(
                                  icon: FaIcon(FontAwesomeIcons.github,
                                      color: Colors.white),
                                  onPressed: () {
                                    launch('https://github.com/tiwarivk1511');
                                  },
                                  label: const Text(
                                    'GitHub',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ))
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
