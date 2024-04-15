import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();
  final subjectController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
      appBar: AppBar(
        title: const Text(
          'Contact Us',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset(
            'assets/background.svg', // Replace with your SVG file
            fit: BoxFit.cover,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withOpacity(0.5),
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.height / 2 + 100,
                  width: MediaQuery.of(context).size.width / 2 + 150,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 5),
                        blurRadius: 10,
                        spreadRadius: 1,
                        color: Colors.grey[300]!,
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Contact Us',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextFormField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              hintText: 'Name',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '*Required';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              hintText: 'Email',
                            ),
                            validator: (email) {
                              if (email == null || email.isEmpty) {
                                return 'Required*';
                              } else if (!EmailValidator.validate(email)) {
                                return 'Please enter a valid Email';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: subjectController,
                            decoration: const InputDecoration(
                              hintText: 'Subject',
                            ),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Required*';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: messageController,
                            decoration: const InputDecoration(
                              hintText: 'Message',
                            ),
                            maxLines: 5,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '*Required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 40),
                          SizedBox(
                            height: 45,
                            width: 110,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: const Color(0xff151534),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  //TODO: send email
                                  sendEmail();
                                }
                              },
                              child: const Text(
                                'Send',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void sendEmail() async {
    String sendEmailTo = 'vikash15112000@gmail.com'; // Receiver email
    String userName = nameController.text;
    String userEmail = emailController.text; // Sender email
    String subject = subjectController.text;
    String message = messageController.text;

    // Construct the mailto link with proper encoding
    String mailToLink = 'mailto:$sendEmailTo'
        '?subject=${Uri.encodeFull(subject)}'
        '&body=${Uri.encodeFull('Name: $userName \nEmail: $userEmail \n' + '\nMessage: ' + '\n$message')}';

    // Print the email link (for testing)
    print(mailToLink);

    // Launch the default email client with the pre-filled email details
    try {
      launchUrl(Uri.parse(mailToLink));
      if (await launchUrl(mailToLink as Uri)) {
        // Email client successfully opened
        nameController.clear();
        emailController.clear();
        subjectController.clear();
        messageController.clear();
      } else {
        throw 'Could not launch email client';
      }
    } catch (e) {
      print('Error launching email client: $e');
    }
  }
}

class EmailValidator {
  static bool validate(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }
}
