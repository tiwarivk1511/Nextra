import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperProfileScreen extends StatefulWidget {
  const DeveloperProfileScreen({Key? key}) : super(key: key);

  @override
  _DeveloperProfileScreenState createState() => _DeveloperProfileScreenState();
}

class _DeveloperProfileScreenState extends State<DeveloperProfileScreen> {
  @override
  Widget build(BuildContext context) {
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
                    // Replace with your profile image link
                    backgroundImage: NetworkImage(
                        'https://media.licdn.com/dms/image/D4D03AQFHzBtz16_10w/profile-displayphoto-shrink_200_200/0/1691164256762?e=1717632000&v=beta&t=lLeOvNQfO8nC7DNMKYa-VqAZlgrsLTg1hYDH_q1Bp2o'),
                  ),

                  // Profile Image

                  SizedBox(height: 20),
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
                  SizedBox(height: 20),
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
                  SizedBox(height: 20),
                  const Card(
                    elevation: 5,
                    color: Colors.blueGrey,
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Experience:',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '1.3 years',
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
                  const SizedBox(height: 30),
                  const Text(
                    'Skills:',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 10),

                  //technology cards
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
                            'https://www.ingemark.com/wp-content/uploads/2021/05/flutter-980x550.jpg'),
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
                  //companies cards
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
                  //Add Contact details
                  Row(children: [
                    IconButton(
                      onPressed: () {
                        launch('mailto:vikash1511@gmail.com');
                      },
                      icon: const Icon(Icons.email_outlined),
                      color: Colors.white,
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.call_outlined)),
                  ])
                ],
              )),
            ),
          ),
        ],
      ),
    );
  }
}
