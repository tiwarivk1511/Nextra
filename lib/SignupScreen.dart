import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:nextra/API_Holder.dart';
import 'package:nextra/LoginScreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final apiKey = API_Holder.apiKey;
  final projectId = "nextra-71204";

  bool _passwordVisible = false;

  Future<void> _saveUserDetails(String userId) async {
    final String databaseUrl =
        'https://nextra-71204-default-rtdb.asia-southeast1.firebasedatabase.app/users/$userId.json?auth=$apiKey';

    final userDetails = {
      'username': _usernameController.text.trim(),
      'email': _emailController.text.trim(),
      'age': _ageController.text.trim(),
      'city': _cityController.text.trim(),
      'country': _countryController.text.trim(),
      'joining_date': DateTime.now().toString(),
    };

    try {
      final response = await http.post(
        Uri.parse(databaseUrl),
        body: json.encode(userDetails),
      );

      if (response.statusCode == 200) {
        print('User details saved successfully');
        //show success message popup
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('User details saved successfully!'),
        ));
        //finish the current screen and navigate to HomeScreen
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ));
      } else {
        print('Failed to save user details');
        print('Error message: ${response.body}');
        // Show error message to the user
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to save user details'),
        ));
      }
    } catch (error) {
      print('Error: $error');
      // Show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error saving user details'),
      ));
    }
  }

  Future<void> _signUp() async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
          'returnSecureToken': true,
        }),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        print('Sign up successful');
        print('User ID: ${responseData['localId']}');
        _saveUserDetails(responseData['localId']);
        // Navigate to Home Screen after successful login with the user ID
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ));
      } else {
        print('Sign up failed');
        print('Error message: ${responseData['error']['message']}');
        // Show error message to the user
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(responseData['error']['message']),
        ));
      }
    } catch (error) {
      print('Error: $error');
      // Show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
      ));
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
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
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 60.0),
                      const Image(
                        image: AssetImage('assets/logo.png'),
                        width: 80,
                        height: 80,
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      TextField(
                        controller: _usernameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Username',
                          hintStyle: const TextStyle(color: Colors.white70),
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: const TextStyle(color: Colors.white70),
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextField(
                        controller: _passwordController,
                        style: const TextStyle(color: Colors.white),
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: const TextStyle(color: Colors.white70),
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Age',
                          hintStyle: const TextStyle(color: Colors.white70),
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextField(
                        controller: _cityController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'City',
                          hintStyle: const TextStyle(color: Colors.white70),
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextField(
                        controller: _countryController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Country',
                          hintStyle: const TextStyle(color: Colors.white70),
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _signUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(255, 255, 255, 1),
                            foregroundColor:
                                const Color.fromRGBO(32, 29, 43, 1),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 60, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                              color: Color.fromRGBO(32, 29, 43, 1),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(width: 10.0),
                          GestureDetector(
                            onTap: () {
                              // Navigate to login screen
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
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
}
