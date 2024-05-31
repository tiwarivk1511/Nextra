import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:nextra/API_Holder.dart';

class ChatWithBotScreen extends StatefulWidget {
  const ChatWithBotScreen({super.key});

  @override
  _ChatWithBotScreenState createState() => _ChatWithBotScreenState();
}

class _ChatWithBotScreenState extends State<ChatWithBotScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];
  late String response;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = ChatMessage(
      text: text,
      isUser: true,
    );
    setState(() {
      _messages.insert(0, message);
    });
    _getBotResponse(text);
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
    final String ApiKey = API_Holder.apiKey;
    // Define the API endpoint URL
    String apiUrl =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$ApiKey';

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

          //if textResponse have Gemini word the replace it to Nextra
          if (textResponse.contains('Gemini')) {
            textResponse = textResponse.replaceAll('Gemini', 'Nextra');
          }

          if (textResponse.contains('Google')) {
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

  Future<void> _getBotResponse(String query) async {
    try {
      // Simulate processing time
      await Future.delayed(const Duration(seconds: 1));

      if (query.toLowerCase().contains('your name')) {
        response = 'I am Nextra. How can I assist you?';
      } else if (query.toLowerCase().contains('bye')) {
        response = 'Goodbye! Have a great day!';
      } else {
        String generatedResponse = await getResponse(query);
        response = generatedResponse ?? '';
      }

      ChatMessage botMessage = ChatMessage(
        text: response,
        isUser: false,
      );
      setState(() {
        _messages.insert(0, botMessage);
      });
    } catch (e) {
      print('Error in _getBotResponse: $e');
    }
  }

  void copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: response));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Translated text copied to clipboard')),
    );
  }

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
        title: const Text('Chat with Bot',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Stack(
        children: [
          // Background SVG image
          SvgPicture.asset(
            'assets/background.svg',
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          // Blur effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withOpacity(0.3),
              child: Column(
                children: <Widget>[
                  Flexible(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      reverse: true,
                      itemCount: _messages.length,
                      itemBuilder: (_, int index) => _messages[index],
                    ),
                  ),
                  const Divider(height: 1.0),
                  Container(
                    decoration:
                    BoxDecoration(color: Theme.of(context).cardColor),
                    child: _buildTextComposer(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: const IconThemeData(color: Colors.white),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Enter your message/query',
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: Colors.purple),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessage({super.key, required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment:
        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          isUser
              ? Container()
              : const CircleAvatar(
            radius: 20.0,
            backgroundImage: AssetImage('assets/logo.png'),
          ), // Bot's avatar
          const SizedBox(width: 8.0),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: isUser ? Colors.blueAccent : Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      text,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  if (!isUser)
                    IconButton(
                      icon: const Icon(Icons.content_copy),
                      onPressed: () {
                        _copyToClipboard(context);
                      },
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          isUser
              ? const CircleAvatar(
            radius: 20.0,
            child: Icon(Icons.person, color: Colors.blueGrey),
          )
              : Container(), // User's avatar
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Response copied to clipboard')),
    );
  }
}