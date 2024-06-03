import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:nextra/API_Holder.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchWithImageScreen extends StatefulWidget {
  const SearchWithImageScreen({Key? key});

  @override
  _SearchWithImageScreenState createState() => _SearchWithImageScreenState();
}

class _SearchWithImageScreenState extends State<SearchWithImageScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];
  File? _image;
  final picker = ImagePicker();
  bool _isLoading = false; // Added loading flag

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

  Future<Map<String, dynamic>?> getResponse(String query, File? image) async {
    try {
      final String apiKey = API_Holder.apiKey; // Replace with your API key
      final String apiUrl =
          'https://vision.googleapis.com/v1/images:annotate?key=$apiKey';

      // Read image bytes and encode to base64
      List<int> imageBytes = await image!.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      // Create request body for web detection
      Map<String, dynamic> requestBody = {
        "requests": [
          {
            "image": {"content": base64Image},
            "features": [
              {"type": "WEB_DETECTION"}
            ]
          }
        ]
      };

      // Convert the request body to JSON
      String requestBodyJson = jsonEncode(requestBody);

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
        print("API response: $responseData"); // Debug statement
        return responseData;
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
      setState(() {
        _isLoading = true; // Set loading flag to true
      });

      await Future.delayed(const Duration(seconds: 1));

      Map<String, dynamic>? response = await getResponse(query, image);

      if (response != null) {
        List<TextSpan> textResponse = _parseWebDetection(response);
        String description = _extractDescription(response);

        ChatMessage botMessage = ChatMessage(
          textSpans: textResponse,
          isUser: false,
          text: description,
        );

        setState(() {
          _messages.insert(0, botMessage);
          _isLoading = false; // Clear loading flag when response received
        });
      }
    } catch (e) {
      print('Error in _getBotResponse: $e');
      setState(() {
        _isLoading = false; // Clear loading flag on error
      });
    }
  }

  String _extractDescription(Map<String, dynamic> responseData) {
    try {
      if (responseData.containsKey('responses') &&
          responseData['responses'].isNotEmpty &&
          responseData['responses'][0].containsKey('textAnnotations') &&
          responseData['responses'][0]['textAnnotations'].isNotEmpty) {
        return responseData['responses'][0]['textAnnotations'][0]
            ['description'];
      }
    } catch (e) {
      print('Error extracting description: $e');
    }
    return 'No description found.';
  }

  List<TextSpan> _parseWebDetection(Map<String, dynamic> responseData) {
    List<TextSpan> spans = [];
    List<String> imageUrl = [];

    if (responseData.containsKey('responses') &&
        responseData['responses'].isNotEmpty &&
        responseData['responses'][0].containsKey('webDetection')) {
      Map<String, dynamic> webDetection =
          responseData['responses'][0]['webDetection'];

      // Extract web entities
      if (webDetection.containsKey('webEntities')) {
        spans.add(const TextSpan(
            text: "Web Entities:\n",
            style: TextStyle(fontWeight: FontWeight.bold)));
        for (var entity in webDetection['webEntities']) {
          if (entity.containsKey('description')) {
            spans.add(TextSpan(
              text: entity['description'] + "\n",
              style: TextStyle(color: Colors.black),
            ));
          }
        }
      }

      // Extract visually similar images
      if (webDetection.containsKey('visuallySimilarImages')) {
        spans.add(const TextSpan(
            text: "\nVisually Similar Images:\n",
            style: TextStyle(fontWeight: FontWeight.bold)));
        for (var image in webDetection['visuallySimilarImages']) {
          if (image.containsKey('url')) {
            String imageUrlText = image['url'];
            imageUrl.add(imageUrlText); // Add to imageUrl list
            spans.add(TextSpan(
              text: imageUrlText + "\n",
              style: TextStyle(color: Colors.blueAccent),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  await launch(imageUrlText);
                },
            ));
          }
        }
      }

      // Combine web entities and visually similar images
      if (spans.isNotEmpty) {
        spans.add(const TextSpan(text: '\n')); // Add a newline between sections
      }
    } else {
      spans.add(const TextSpan(text: 'No web detection results found.\n'));
    }

    // Add each imageUrl as a separate TextSpan
    for (String url in imageUrl) {
      spans.add(TextSpan(
          text: url + "\n", style: TextStyle(color: Colors.blueAccent)));
    }

    return spans;
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
                      itemCount: _messages.length + 1,
                      itemBuilder: (_, int index) {
                        if (index == _messages.length) {
                          return _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : Container();
                        }
                        return _messages[index];
                      },
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
  final List<TextSpan> textSpans;
  final bool isUser;
  final File? image;

  const ChatMessage({
    Key? key,
    required this.text,
    this.textSpans = const [],
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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Image.file(
                        image!,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  if (textSpans.isNotEmpty)
                    RichText(
                      text: TextSpan(children: textSpans),
                    )
                  else
                    Text(
                      text,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black,
                        fontSize: 16.0,
                      ),
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
}
