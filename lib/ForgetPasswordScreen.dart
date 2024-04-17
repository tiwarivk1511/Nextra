import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({Key? key});

  final apiKey = "AIzaSyD-WktVvIdMXJ6kV99h92PYFRhUQ_1xNmQ";

  Future<void> _resetPassword(String email, BuildContext context) async {
    try {
      final checkUserUrl = Uri.parse(
          'https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=$apiKey');
      final response = await http.post(
        checkUserUrl,
        body: json.encode({
          'email': [email],
        }),
        headers: {'Content-Type': 'application/json'},
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200 &&
          responseData['users'] != null &&
          responseData['users'].isNotEmpty) {
        // Email exists, send password reset email
        final url = Uri.parse(
            'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=$apiKey');
        final resetResponse = await http.post(
          url,
          body: json.encode({
            'requestType': 'PASSWORD_RESET',
            'email': email,
          }),
          headers: {'Content-Type': 'application/json'},
        );

        if (resetResponse.statusCode == 200) {
          // Show a success message or navigate to another screen
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Password reset email sent. Check your inbox.'),
            ),
          );
        } else {
          // Handle errors
          print('Error sending password reset email: ${resetResponse.body}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error sending password reset email.'),
            ),
          );
        }
      } else {
        // Email does not exist
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Email not found. Please enter a registered email address.'),
          ),
        );
      }
    } catch (e) {
      // Handle exceptions
      print('Exception occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sending password reset email.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset(
            'assets/background.svg',
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.8),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
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
                      'Forget Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 40.0),
                    TextField(
                      controller: emailController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        hintStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Call reset password function
                          _resetPassword(emailController.text.trim(), context);
                        },
                        child: Text('Send OTP'),
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
