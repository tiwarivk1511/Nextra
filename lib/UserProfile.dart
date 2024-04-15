import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _bio = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
  TextEditingController newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Ensures full background coverage
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
          onPressed: () =>
              Navigator.of(context).pop(), // Concise arrow press handling
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
          // Blur effect container with slight transparency for better readability
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black
                    .withOpacity(0.2), // Adjust opacity for desired blur effect
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Left-align content
                    children: [
                      // Profile Picture & Name
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white,
                                  width:
                                      2.0), // White border around profile picture
                            ),
                            child: const ClipOval(
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(
                                    'https://icons8.com/icon/kDoeg22e5jUY/male-user'), // Replace with user's image URL
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          const Text(
                            'John Doe', // Replace with user's name
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Bio Section (Replace with user's bio)
                      const Text(
                        'Bio',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white, // Lighter white for headings
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        initialValue: _bio,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Enter your bio',
                        ),
                        maxLines: 3,
                        onChanged: (value) {
                          _bio = value;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Information Sections (Replace with user's information)
                      Text(
                        'Information',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Card(
                        color: Colors.blueGrey.withOpacity(0.5),
                        child: ListTile(
                          leading: const Icon(Icons.location_on,
                              color: Colors.white),
                          title: const Text(
                            'Location',
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: const Text(
                            'City, State, Country',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        color: Colors.blueGrey.withOpacity(0.5),
                        child: ListTile(
                          leading: const Icon(Icons.link, color: Colors.white),
                          title: const Text(
                            'Website',
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: const Text(
                            'https://example.com',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        color: Colors.blueGrey.withOpacity(0.5),
                        child: ListTile(
                          leading: const Icon(Icons.calendar_today,
                              color: Colors.white),
                          title: const Text(
                            'Date of Joining',
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: const Text(
                            '01 Jan 2023', // Replace with actual date
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        color: Colors.blueGrey.withOpacity(0.5),
                        child: ListTile(
                          leading: const Icon(Icons.contact_phone,
                              color: Colors.white),
                          title: const Text(
                            'Contact Details',
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: const Text(
                            '+1234567890', // Replace with actual contact details
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        color: Colors.blueGrey.withOpacity(0.5),
                        child: ListTile(
                          leading: const Icon(Icons.lock, color: Colors.white),
                          title: const Text(
                            'Change Password',
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: _updatePassword,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Card(
                        color: Colors.blueGrey.withOpacity(0.5),
                        child: ListTile(
                          leading: const Icon(Icons.exit_to_app,
                              color: Colors.white),
                          title: const Text(
                            'Sign Out',
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: _signOut,
                        ),
                      ),
                      // Add more Card widgets for other information
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editBio() {
    TextEditingController bioController = TextEditingController(text: _bio);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Bio'),
          content: TextField(
            controller: bioController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Enter your bio',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  _bio = bioController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _updatePassword() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Password'),
          content: TextField(
            controller: newPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Enter new password',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Here you can implement logic to update the password in your backend or wherever it's stored
                String newPassword = newPasswordController.text;
                // Example: Call an API to update the password

                // After updating the password, close the dialog
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _signOut() {
    // Implement sign out functionality here
  }
}
