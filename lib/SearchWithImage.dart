import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class SearchWithImageScreen extends StatefulWidget {
  @override
  _SearchWithImageScreenState createState() => _SearchWithImageScreenState();
}

class _SearchWithImageScreenState extends State<SearchWithImageScreen> {
  final TextEditingController _textController = TextEditingController();
  File? _image;
  final picker = ImagePicker();
  final List<ChatMessage> _messages = <ChatMessage>[];

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  Future<String> _sendToGoogleVision(File? image) async {
    if (image == null) {
      throw Exception('Image not provided');
    }
    final visionUrl = Uri.parse(
        'https://vision.googleapis.com/v1/images:annotate?key=YOUR_API_KEY_HERE');
    final request = {
      'requests': [
        {
          'image': {'content': base64Encode(image.readAsBytesSync())},
          'features': [
            {'type': 'WEB_DETECTION'}, // Add more feature types as needed
          ],
        },
      ],
    };
    final response = await http.post(visionUrl, body: jsonEncode(request));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      // Parse and extract relevant information from the response
      // Example: Find objects, animals, plants, landmarks, etc.
      // Example: Identify people in images
      // Example: Detect text in images
      // Example: Analyze image properties (colors, etc.)
      // Example: Extract logos, brands, etc.
      // Combine and format the information into a human-readable format
      // Return the formatted response
      return _parseGoogleVisionResponse(jsonResponse);
    } else {
      throw Exception('Failed to process image: ${response.reasonPhrase}');
    }
  }

  String _parseGoogleVisionResponse(Map<String, dynamic> response) {
    // Implement parsing logic based on the Google Vision API response
    // Combine and format the information into a human-readable format
    return 'Google Vision Response';
  }

  Future<String> _sendToGemini(String text) async {
    final apiUrl = Uri.parse('https://api.gemini.circuitverse.org/api/search');
    final response = await http.post(apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'query': text}));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final results = jsonResponse['results'] as List;
      final firstResult = results.first;
      final description = firstResult['description'];
      return description;
    } else {
      throw Exception('Failed to process text: ${response.reasonPhrase}');
    }
  }

  Future<String> _sendRequest(String text, File? image) async {
    try {
      final visionResponse = await _sendToGoogleVision(image);
      final geminiResponse = await _sendToGemini(text);
      return '$visionResponse\n\n$geminiResponse';
    } catch (e) {
      print('Error: $e');
      return 'Error: $e';
    }
  }

  void _handleSubmitted(String text, File? image) async {
    _textController.clear();
    try {
      final botResponse = await _sendRequest(text, image);
      setState(() {
        _messages.insert(
            0, ChatMessage(text: text, isUser: true, image: image));
        _messages.insert(0, ChatMessage(text: botResponse, isUser: false));
        _image = null;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Widget _buildTextComposer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.image),
              onPressed: () {
                _showImageUploadPopup();
              },
            ),
            Expanded(
              child: TextField(
                controller: _textController,
                onSubmitted: (text) {
                  _handleSubmitted(text, _image);
                },
                decoration: InputDecoration.collapsed(
                  hintText: 'Send a message',
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                _handleSubmitted(_textController.text, _image);
              },
            ),
          ],
        ),
        SizedBox(height: 8.0),
        _image != null
            ? Image.file(_image!,
                height: 100.0, width: 100.0, fit: BoxFit.cover)
            : Container(),
      ],
    );
  }

  Future<void> _showImageUploadPopup() async {
    final action = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Upload Image"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text("Take a Picture"),
                  onTap: () {
                    Navigator.of(context).pop(ImageSource.camera);
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text("Choose from Gallery"),
                  onTap: () {
                    Navigator.of(context).pop(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
    if (action != null) {
      _getImage(action);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search with Image'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (_, int index) => _messages[index],
            ),
          ),
          Divider(height: 1.0, color: Colors.white),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            color: Theme.of(context).cardColor.withOpacity(0.7),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;
  final File? image;

  ChatMessage({required this.text, required this.isUser, this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          isUser
              ? Container()
              : CircleAvatar(
                  radius: 20.0,
                  child: Icon(Icons.account_circle),
                ),
          SizedBox(width: 8.0),
          Column(
            crossAxisAlignment:
                isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (image != null) Image.file(image!, width: 100, height: 100),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: isUser ? Colors.blueAccent : Colors.grey[300],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    color: isUser ? Colors.white : Colors.black,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 8.0),
          isUser
              ? CircleAvatar(
                  radius: 20.0,
                  child: Icon(Icons.account_circle),
                )
              : Container(),
        ],
      ),
    );
  }
}
