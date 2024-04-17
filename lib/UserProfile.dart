import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String _username = '';
  String _bio = '';
  String _location = '';
  String _website = '';
  String _joiningDate = '';
  String _contactDetails = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch user data when the screen is initialized
  }

  Future<void> _fetchUserData() async {
    final userId = ''; // Replace with the user's ID
    final databaseUrl =
        'https://nextra-71204-default-rtdb.asia-southeast1.firebasedatabase.app/users/$userId.json';

    try {
      final response = await http.get(Uri.parse(databaseUrl));

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        setState(() {
          _username = userData['username'] ?? '';
          _bio = userData['bio'] ?? '';
          _location = userData['location'] ?? '';
          _website = userData['website'] ?? '';
          _joiningDate = userData['joining_date'] ?? '';
          _contactDetails = userData['contact_details'] ?? '';
        });
      } else {
        print('Failed to fetch user data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'User Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset(
            'assets/background.svg',
            fit: BoxFit.cover,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2.0,
                            ),
                          ),
                          child: const ClipOval(
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                  'https://icons8.com/icon/kDoeg22e5jUY/male-user'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          _username,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Bio',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _bio,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Information',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Display user information here
                    // Example:
                    _buildInfoCard(
                      icon: Icons.location_on,
                      title: 'Location',
                      subtitle: _location,
                    ),
                    const SizedBox(height: 10),
                    _buildInfoCard(
                      icon: Icons.link,
                      title: 'Website',
                      subtitle: _website,
                    ),
                    const SizedBox(height: 10),
                    _buildInfoCard(
                      icon: Icons.calendar_today,
                      title: 'Date of Joining',
                      subtitle: _joiningDate,
                    ),
                    const SizedBox(height: 10),
                    _buildInfoCard(
                      icon: Icons.contact_phone,
                      title: 'Contact Details',
                      subtitle: _contactDetails,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      color: Colors.blueGrey.withOpacity(0.5),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.white,
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
