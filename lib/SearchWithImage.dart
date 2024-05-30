import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:nextra/API_Holder.dart';
import 'package:path_provider/path_provider.dart';

class SearchWithImageScreen extends StatefulWidget {
  const SearchWithImageScreen({super.key});

  @override
  _SearchWithImageScreenState createState() => _SearchWithImageScreenState();
}

class _SearchWithImageScreenState extends State<SearchWithImageScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];
  late String response;
  late String textResponse;
  File? _image;
  final picker = ImagePicker();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text, File? image) {
    _textController.clear();
    ChatMessage message = ChatMessage(
      text: text,
      isUser: true,
      image: image,
    );
    setState(() {
      _messages.insert(0, message);
    });
    _getBotResponse(text, image);
  }

  Future<String?> getResponse(String query, File? image) async {
    try {
      final String apiKey = API_Holder.apiKey; // Replace with your API key
      final String apiUrl =
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro-vision:generateContent?key=$apiKey';

      // Initialize the request body
      Map<String, dynamic> requestBody = {
        "contents": [
          {
            "parts": [
              {"text": query},
            ]
          }
        ]
      };

      // Add image to the request body if available
      if (image != null) {
        List<int> imageBytes = await image.readAsBytes();
        String base64Image = base64Encode(imageBytes);

        // Add base64 image to request body
        requestBody["contents"][0]["parts"].add({
          "inline_data": {"mime_type": "image/jpeg", "data": base64Image}
        });
      }

      // Convert the request body to JSON
      String requestBodyJson = jsonEncode(requestBody);

      print('Request Body: $requestBodyJson'); // Debugging

      // Make the HTTP POST request
      http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: requestBodyJson,
      );

      print('Response Status Code: ${response.statusCode}'); // Debugging
      print('Response Body: ${response.body}'); // Debugging

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Parse the response JSON
        Map<String, dynamic> responseData = jsonDecode(response.body);

        // Extract and return the response text
        if (responseData.containsKey('responses') &&
            responseData['responses'].isNotEmpty &&
            responseData['responses'][0].containsKey('content') &&
            responseData['responses'][0]['content'].isNotEmpty) {
          String textResponse =
              responseData['responses'][0]['content'][0]['text'];
          print('Extracted Text Response: $textResponse'); // Debugging
          return textResponse;
        } else {
          print("Error: 'content' field is missing in the response.");
          throw Exception('Failed to get valid response');
        }
      } else {
        // If the request was not successful, print the error response
        print("Error response: ${response.body}");
        throw Exception('Failed to load response');
      }
    } catch (e) {
      // If an error occurred during the request, print the error
      print('Error: $e');
      return null;
    }
  }

  Future<void> _getBotResponse(String query, File? image) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      String? generatedResponse;

      if (image != null) {
        // Load the image using the image package
        final bytes = await image.readAsBytes();
        final img.Image? originalImage = img.decodeImage(bytes);

        if (originalImage != null) {
          // Example: Convert the image to grayscale
          final img.Image processedImage = img.grayscale(originalImage);

          // Save the processed image to a temporary file
          final Directory tempDir = await getTemporaryDirectory();
          final String tempPath = '${tempDir.path}/temp.jpg';
          File(tempPath).writeAsBytesSync(img.encodeJpg(processedImage));

          // Pass the processed image path to your API
          generatedResponse = await getResponse(query, File(tempPath));
        } else {
          print("Error: Unable to decode image.");
          generatedResponse = 'Error: Unable to process image.';
        }
      } else {
        generatedResponse = await getResponse(query, null);
      }

      // Convert the response to string
      String textResponse = generatedResponse ?? 'No response';

      // Update the response
      ChatMessage botMessage = ChatMessage(
        text: textResponse,
        isUser: false,
      );

      setState(() {
        _messages.insert(0, botMessage);
      });
    } catch (e) {
      print('Error in _getBotResponse: $e');
    }
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
    });
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
        title: const Text(
          'Search with Image',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.image, color: Colors.purple),
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
                decoration: const InputDecoration.collapsed(
                  hintText: 'Send a message',
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: Colors.purple),
              onPressed: () {
                _handleSubmitted(_textController.text, _image);
                _image = null;
              },
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        _image != null
            ? Image.file(
                _image!,
                height: 50.0,
                width: 50.0,
                fit: BoxFit.contain,
              )
            : Container(),
      ],
    );
  }

  Future<void> _showImageUploadPopup() async {
    final action = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Upload Image"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Text("Take a Picture"),
                  onTap: () {
                    Navigator.of(context).pop(ImageSource.camera);
                  },
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: const Text("Choose from Gallery"),
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
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;
  final File? image;

  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
    this.image,
  });

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
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (image != null)
                    Image.file(
                      image!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          icon: const Icon(Icons.copy, color: Colors.grey),
                          onPressed: () {
                            _copyToClipboard(context);
                          },
                        ),
                    ],
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
