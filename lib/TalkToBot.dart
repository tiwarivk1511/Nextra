import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class TalkToBot extends StatefulWidget {
  const TalkToBot({super.key});

  @override
  State<TalkToBot> createState() => _TalkToBotState();
}

class _TalkToBotState extends State<TalkToBot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isAnimating = false;
  bool _isListening = false;
  final stt.SpeechToText _speech = stt.SpeechToText();
  FlutterTts flutterTts = FlutterTts();
  String _userQuery = '';
  String _botResponse = '';

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reset();
          _isAnimating = false;
        } else if (status == AnimationStatus.dismissed) {
          _isAnimating = true;
        }
      });

    _controller.forward();

    // Start the loop
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isAnimating) {
        _controller.forward();
      }
    });

    _checkMicPermission();
  }

  @override
  void dispose() {
    _controller.dispose();
    // Turn off TTS when the widget is disposed
    flutterTts.stop();
    super.dispose();
  }

  void _checkMicPermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  }

  void _listenForSpeech() async {
    if (!_speech.isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          setState(() {
            _isListening =
                status == stt.SpeechToText.withMethodChannel().listen;
            print('onStatus: $status');
          });
        },
        onError: (error) => print('onError: $error'),
      );

      if (available) {
        _speech.listen(
          onResult: (result) {
            setState(() {
              _userQuery = result.recognizedWords;
            });
            // Call a function to process the user's query and get the bot's response
            _getBotResponse(_userQuery);
          },
        );
      }
    } else {
      _speech.stop();
    }
  }

  // void _getBotResponse(String query) async {
  //   // Simulate processing time
  //   Future.delayed(const Duration(seconds: 1), () async {
  //     String response;
  //     if (query.toLowerCase().contains('your name')) {
  //       response = 'I am Nextra . How can I assist you?';
  //     } else if (query.toLowerCase().contains('bye')) {
  //       response = 'Goodbye! Have a great day!';
  //     } else {
  //       Map<String, String> responseMap =
  //       (await getResponse(query)) as Map<String, String>;
  //       response = responseMap['text'] ?? '';
  //     }
  //     setState(() {
  //       _botResponse = getResponse(query) as String;
  //     });
  //     await flutterTts.speak(response);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Talk To Bot',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromRGBO(32, 29, 43, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
            //turn off TTS
            flutterTts.stop();
          },
        ),
      ),
      body: Container(
        color: const Color.fromRGBO(32, 29, 43, 1),
        width: double.maxFinite,
        height: double.maxFinite,
        alignment: Alignment.center,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background SVG with blur effect
            SvgPicture.asset(
              'assets/background.svg',
              fit: BoxFit.cover,
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return _isAnimating
                                ? const SizedBox()
                                : _controller.value < 0.5
                                    ? Image.asset(
                                        'assets/nebulaImg1.png',
                                        height: 200,
                                        width: 200,
                                      )
                                    : Image.asset(
                                        'assets/nebulaImg2.png',
                                        height: 200,
                                        width: 200,
                                      );
                          },
                        ),
                        const SizedBox(
                          height: 250,
                        ),
                        Text(
                          _isListening
                              ? 'Listening...'
                              : _userQuery.isEmpty
                                  ? 'Press icon to talk'
                                  : _userQuery,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                        if (_isListening)
                          const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        if (_botResponse.isNotEmpty)
                          Text(
                            _botResponse,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        const SizedBox(
                          height: 55,
                        ),
                        SizedBox(
                          width: double.maxFinite,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  height: 55,
                                  width: 55,
                                  child: Card(
                                    color: Colors.deepPurple.shade200,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    child: Center(
                                      child: IconButton(
                                        onPressed: () {
                                          // Add your onPressed logic here
                                        },
                                        icon: Image.asset(
                                          'assets/keyboardImg.png',
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                //Image
                                SizedBox(
                                  width: 170,
                                  height: 170,
                                  child: IconButton(
                                    icon: Image.asset('assets/botImg.png'),
                                    onPressed: _listenForSpeech,
                                  ),
                                ),

                                SizedBox(
                                  height: 55,
                                  width: 55,
                                  child: Card(
                                    color: Colors.black26,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    child: Center(
                                      child: IconButton(
                                        onPressed: () {
                                          // turn off TTS
                                          flutterTts.stop();
                                        },
                                        icon: const Icon(
                                          Icons.close_rounded,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> getResponse(String query) async {
    // Define the request body
    Map<String, dynamic> requestBody = {
      "contents": [
        {
          "parts": [
            {"text": query}
          ]
        }
      ]
    };

    // Convert the request body to JSON
    String requestBodyJson = jsonEncode(requestBody);

    // Define the API endpoint URL
    String apiUrl =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyAmYtafCn4SHCmpPILwaMc_qz_QtZD1g1s';

    try {
      // Make the HTTP POST request
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: requestBodyJson,
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Parse the response JSON
        Map<String, dynamic> responseData = jsonDecode(response.body);

        // Check if the response contains candidates
        if (responseData.containsKey('candidates') &&
            responseData['candidates'] is List &&
            responseData['candidates'].isNotEmpty) {
          // Extract the text response from the first candidate
          String textResponse =
              responseData['candidates'][0]['content']['parts'][0]['text'];

          // Replace "Gemini" with "Nextra" and keep "Google" intact
          textResponse = textResponse.replaceAll('Gemini', 'Nextra');
          // Check if the query contains any reference to the app
          if (textResponse.contains('Nextra') ||
              textResponse.toLowerCase().contains('Nextra') ||
              textResponse.toUpperCase().contains('nextra')) {
            textResponse =
                textResponse.replaceAll('Google', 'Vikash Tiwari Sir');
          }

          print("Response: $textResponse");

          return textResponse;
        } else {
          print("No candidates found in the response");
          throw Exception('Failed to load response');
        }
      } else {
        // If the request was not successful, print the error response
        print("Error response: ${response.body}");
        throw Exception('Failed to load response');
      }
    } catch (e) {
      // If an error occurred during the request, print the error
      print('Error: $e');
      return '';
    }
  }

  void _getBotResponse(String query) async {
    try {
      // Simulate processing time
      await Future.delayed(const Duration(seconds: 1));

      String response;
      if (query.toLowerCase().contains('your name')) {
        response = 'I am Nextra. How can I assist you?';
      } else if (query.toLowerCase().contains('bye')) {
        response = 'Goodbye! Have a great day!';
      } else {
        String generatedResponse = await getResponse(query);
        response = generatedResponse ?? '';
      }

      setState(() {
        _botResponse = response;
      });

      await flutterTts.speak(response);
    } catch (e) {
      print('Error in _getBotResponse: $e');
    }
  }
}
