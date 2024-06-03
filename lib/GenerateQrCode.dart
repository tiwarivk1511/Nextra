import 'dart:convert';
import 'dart:io' as io;
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';

import 'API_Holder.dart';

class GenerateQR extends StatefulWidget {
  const GenerateQR({Key? key}) : super(key: key);

  @override
  _GenerateQRState createState() => _GenerateQRState();
}

class _GenerateQRState extends State<GenerateQR> {
  final TextEditingController textController = TextEditingController();

  final TextEditingController urlController = TextEditingController();

  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  final TextEditingController contactNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController vCardEmailController = TextEditingController();

  final TextEditingController wiFiSSIDController = TextEditingController();
  final TextEditingController wiFiPasswordController = TextEditingController();

  final TextEditingController socialMediaLinkController =
      TextEditingController();

  final TextEditingController pdfLinkController = TextEditingController();

  final TextEditingController mp3LinkController = TextEditingController();

  final TextEditingController appStoreLinkController = TextEditingController();

  final TextEditingController imageLinkController = TextEditingController();

  final TextEditingController barcodeDataController = TextEditingController();

  final TextEditingController paymentRecipientController =
      TextEditingController();
  final TextEditingController paymentAmountController = TextEditingController();
  final TextEditingController paymentReferenceController =
      TextEditingController();

  String selectedDataType = '---- Select any option ----';
  String address = '';
  String latitude = '';
  String longitude = '';

  //store the data in an array variable
  List<String> Qr_data = [];

  // API Key
  String apiKey = API_Holder.mapApiKey;

  @override
  void initState() {
    super.initState();

    _requestPermissions();
  }

  // Future method to fetch the current Location
  // Future method to fetch the current Location
  Future<void> _fetchLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        setState(() {
          latitude = '${position.latitude}';
          longitude = '${position.longitude}';
        });

        // Fetch location address using latitude and longitude
        await _fetchAddressFromCoordinates(
            position.latitude, position.longitude);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Location permission is required to fetch the current location.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error fetching location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error fetching location.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _fetchAddressFromCoordinates(
      double latitude, double longitude) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey');

    try {
      final response = await http.get(url);

      print('fetch address: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK') {
          final results = data['results'];
          if (results.isNotEmpty) {
            setState(() {
              address = results[0]['formatted_address'];
            });
          }
        } else {
          print('Error: ${data['status']}');
        }
      } else {
        print('Error fetching address: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _requestPermissions() async {
    final List<Permission> permissionsToRequest = [
      Permission.camera,
      Permission.storage,
      Permission.location,
    ];

    final Map<Permission, PermissionStatus> permissionStatus =
        await permissionsToRequest.request();

    if (permissionStatus[Permission.camera]!.isDenied ||
        permissionStatus[Permission.storage]!.isDenied ||
        permissionStatus[Permission.location]!.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Camera, storage, and location permissions are required for QR code generation.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildInputField() {
    switch (selectedDataType) {
      case 'URL':
        return TextField(
          controller: urlController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter URL to generate QR code',
            hintStyle: const TextStyle(color: Colors.blueGrey),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blueGrey),
              borderRadius: BorderRadius.circular(10),
              gapPadding: 10,
            ),
          ),
        );

      case 'Location':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: latitudeController..text = latitude,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Latitude',
                hintStyle: const TextStyle(color: Colors.blueGrey),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(10),
                  gapPadding: 10,
                ),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: longitudeController..text = longitude,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Longitude',
                hintStyle: const TextStyle(color: Colors.blueGrey),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(10),
                  gapPadding: 10,
                ),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: addressController..text = address,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Address',
                hintStyle: const TextStyle(color: Colors.blueGrey),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(10),
                  gapPadding: 10,
                ),
              ),
              keyboardType: TextInputType.streetAddress,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.location_on, color: Colors.white),
              onPressed: _fetchLocation,
              label: const Text(
                'Fetch Location',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        );

      case 'E-mail':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: emailController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Recipient email address',
                hintStyle: const TextStyle(color: Colors.blueGrey),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(10),
                  gapPadding: 10,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: subjectController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Subject (optional)',
                hintStyle: const TextStyle(color: Colors.blueGrey),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(10),
                  gapPadding: 10,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: messageController,
              style: const TextStyle(color: Colors.white),
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Message body',
                hintStyle: const TextStyle(color: Colors.blueGrey),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(10),
                  gapPadding: 10,
                ),
              ),
            ),
          ],
        );
      case 'V-Card':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: contactNameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter contact name',
                hintStyle: const TextStyle(color: Colors.blueGrey),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(10),
                  gapPadding: 10,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: phoneNumberController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter phone number',
                hintStyle: const TextStyle(color: Colors.blueGrey),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(10),
                  gapPadding: 10,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: vCardEmailController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter email address',
                hintStyle: const TextStyle(color: Colors.blueGrey),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(10),
                  gapPadding: 10,
                ),
              ),
            ),
          ],
        );
      case 'Text':
        return TextField(
          controller: textController,
          style: const TextStyle(color: Colors.white),
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Enter text to generate QR code',
            hintStyle: const TextStyle(color: Colors.blueGrey),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blueGrey),
              borderRadius: BorderRadius.circular(10),
              gapPadding: 10,
            ),
          ),
        );
      case 'SMS':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: phoneNumberController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter recipient phone number',
                hintStyle: const TextStyle(color: Colors.blueGrey),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(10),
                  gapPadding: 10,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: messageController,
              style: const TextStyle(color: Colors.white),
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Enter message',
                hintStyle: const TextStyle(color: Colors.blueGrey),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(10),
                  gapPadding: 10,
                ),
              ),
            ),
          ],
        );
      case 'Wi-Fi':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: wiFiSSIDController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter Wi-Fi SSID',
                hintStyle: const TextStyle(color: Colors.blueGrey),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(10),
                  gapPadding: 10,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: wiFiPasswordController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter Wi-Fi Password',
                hintStyle: const TextStyle(color: Colors.blueGrey),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(10),
                  gapPadding: 10,
                ),
              ),
            ),
          ],
        );
      case 'Social Media':
        return TextField(
          controller: socialMediaLinkController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter social media profile link',
            hintStyle: const TextStyle(color: Colors.blueGrey),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blueGrey),
              borderRadius: BorderRadius.circular(10),
              gapPadding: 10,
            ),
          ),
        );
      case 'PDF':
        return TextField(
          controller: pdfLinkController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter PDF link or file path',
            hintStyle: const TextStyle(color: Colors.blueGrey),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blueGrey),
              borderRadius: BorderRadius.circular(10),
              gapPadding: 10,
            ),
          ),
        );
      case 'MP3':
        return TextField(
          controller: mp3LinkController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter MP3 link or file path',
            hintStyle: const TextStyle(color: Colors.blueGrey),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blueGrey),
              borderRadius: BorderRadius.circular(10),
              gapPadding: 10,
            ),
          ),
        );
      case 'App Stores':
        return TextField(
          controller: appStoreLinkController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter app store link',
            hintStyle: const TextStyle(color: Colors.blueGrey),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blueGrey),
              borderRadius: BorderRadius.circular(10),
              gapPadding: 10,
            ),
          ),
        );
      case 'Images':
        return TextField(
          controller: imageLinkController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter image link or file path',
            hintStyle: const TextStyle(color: Colors.blueGrey),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blueGrey),
              borderRadius: BorderRadius.circular(10),
              gapPadding: 10,
            ),
          ),
        );
      case '2D Barcode':
        return TextField(
          controller: barcodeDataController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter 2D barcode data',
            hintStyle: const TextStyle(color: Colors.blueGrey),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blueGrey),
              borderRadius: BorderRadius.circular(10),
              gapPadding: 10,
            ),
          ),
        );
      case 'Payment':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: paymentRecipientController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter recipient name or ID',
                hintStyle: const TextStyle(color: Colors.blueGrey),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(10),
                  gapPadding: 10,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: paymentAmountController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter amount',
                hintStyle: const TextStyle(color: Colors.blueGrey),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(10),
                  gapPadding: 10,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: paymentReferenceController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter payment reference or message (optional)',
                hintStyle: const TextStyle(color: Colors.blueGrey),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(10),
                  gapPadding: 10,
                ),
              ),
            ),
          ],
        );
      // Add more cases for other data types as needed
      default:
        return TextField(
          controller: textController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter text to generate QR code',
            hintStyle: const TextStyle(color: Colors.blueGrey),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blueGrey),
              borderRadius: BorderRadius.circular(10),
              gapPadding: 10,
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
      appBar: AppBar(
        title: const Text(
          'Generate QR',
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
          // SVG background with blur effect
          SvgPicture.asset(
            'assets/background.svg',
            fit: BoxFit.cover,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withOpacity(0.5),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Dropdown for selecting data type
                  DropdownButton<String>(
                    value: selectedDataType,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDataType = newValue!;
                      });
                    },
                    style: const TextStyle(color: Colors.white),
                    dropdownColor: const Color.fromRGBO(136, 0, 133, 1),
                    items: <String>[
                      '---- Select any option ----',
                      'URL',
                      'E-mail',
                      'V-Card',
                      'Text',
                      'SMS',
                      'Wi-Fi',
                      'Social Media',
                      'PDF',
                      'MP3',
                      'App Stores',
                      'Images',
                      '2D Barcode',
                      'Payment',
                      'Location',
                      // Add more data types here
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 10),
                  _buildInputField(),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      String data = '';

                      // Check the selected data type and set the data accordingly
                      switch (selectedDataType) {
                        case 'URL':
                          data = urlController.text;
                          break;
                        case 'E-mail':
                          // Concatenate email components with appropriate separators
                          data =
                              'recipient:${emailController.text}\n subject:${subjectController.text}\n body:${messageController.text}';
                          break;
                        case 'V-Card':
                          // Concatenate v-card components with appropriate separators
                          data =
                              'Name: ${contactNameController.text}\n Contact Number:${phoneNumberController.text} \n Email:${vCardEmailController.text}';
                          break;
                        case 'Text':
                          data = textController.text;
                          break;
                        case 'SMS':
                          // Concatenate SMS components with appropriate separators
                          data =
                              'Recipient:${phoneNumberController.text}\n Message:${messageController.text}';
                          break;
                        case 'Wi-Fi':
                          // Concatenate Wi-Fi components with appropriate separators
                          data =
                              'SSID:${wiFiSSIDController.text}\n password:${wiFiPasswordController.text}';
                          break;
                        case 'Social Media':
                          data = socialMediaLinkController.text;
                          break;
                        case 'PDF':
                          data = pdfLinkController.text;
                          break;
                        case 'MP3':
                          data = mp3LinkController.text;
                          break;
                        case 'App Stores':
                          data = appStoreLinkController.text;
                          break;
                        case 'Images':
                          data = imageLinkController.text;
                          break;
                        case '2D Barcode':
                          data = barcodeDataController.text;
                          break;
                        case 'Payment':
                          // Concatenate payment components with appropriate separators
                          data =
                              'recipient name or ID:${paymentRecipientController.text} \n amount:${paymentAmountController.text}\n description:${paymentReferenceController.text}';
                          break;
                        case 'Location':
                          // Concatenate location components with appropriate separators
                          data =
                              'Latitude: ${latitudeController.text}, Longitude: ${longitudeController.text}, Address: ${addressController.text}';
                          break;
                        default:
                          break;
                      }

                      // Now 'data' contains the dynamic data based on the selected data type
                      // Use 'data' as needed

                      if (data.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content:
                              Text('Please enter data to generate QR code.'),
                        ));
                      } else if (selectedDataType ==
                          '---- Select any option ----') {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Please select a data type.'),
                        ));
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => GeneratedQrCodeScreen(
                            text: data,
                            dataType: selectedDataType,
                          ),
                        ));
                      }
                    },
                    icon: const Icon(Icons.qr_code_2_rounded),
                    label: const Text('Generate QR'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
                      foregroundColor: const Color.fromRGBO(32, 29, 43, 1),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GeneratedQrCodeScreen extends StatelessWidget {
  final String text;
  final String dataType;

  const GeneratedQrCodeScreen({
    Key? key,
    required this.text,
    required this.dataType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Your Generated $dataType QR Code',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: SvgPicture.asset(
                'assets/background.svg', // Replace with your SVG file
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                QrCodeScreen(text: text).buildQrCode(),
                const SizedBox(
                    width: 20), // Add spacing between the QR code and buttons
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
                        foregroundColor: const Color.fromRGBO(32, 29, 43, 1),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => _shareQrCode(context, text),
                      child: const Text('Share QR'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
                        foregroundColor: const Color.fromRGBO(32, 29, 43, 1),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 60, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => _saveQrCode(context, text),
                      child: const Text('Save QR'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _shareQrCode(BuildContext context, String text) async {
    try {
      // Generate QR code as an image
      final qrValidationResult = QrValidator.validate(
        data: text,
        version: QrVersions.auto,
        errorCorrectionLevel: QrErrorCorrectLevel.Q,
      );
      final qrCode = qrValidationResult.qrCode;
      final painter = QrPainter.withQr(
        qr: qrCode!,
        color: const Color(0xFF000000),
        emptyColor: const Color(0xFFFFFFFF),
        gapless: true,
        embeddedImageStyle: null,
        embeddedImage: null,
      );

      // Convert QR code to image data
      final imageData =
          await painter.toImageData(2048, format: ImageByteFormat.png);

      // Save QR code image to temporary directory
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/qr_code.png';
      final file = io.File(filePath);
      await file.writeAsBytes(imageData!.buffer.asUint8List());

      // Share the QR code image
      await Share.shareFiles([file.path], text: 'Check out this QR code!');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing QR code: $e')),
      );
    }
  }
}

Future<void> _saveQrCode(BuildContext context, String text) async {
  try {
    // Get the application support directory
    final directory = (await getApplicationSupportDirectory()).path;
    String filePath = '$directory/qr_code.png';

    // Generate QR code as an image
    final qrValidationResult = QrValidator.validate(
      data: text,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.Q,
    );
    final qrCode = qrValidationResult.qrCode;
    final painter = QrPainter.withQr(
      qr: qrCode!,
      color: const Color(0xFF000000),
      emptyColor: const Color(0xFFFFFFFF),
      gapless: true,
      embeddedImageStyle: null,
      embeddedImage: null,
    );

    // Save QR code as image file
    final image = await painter.toImageData(2048, format: ImageByteFormat.png);
    final buffer = image!.buffer.asUint8List();
    final file = io.File(filePath);
    await file.writeAsBytes(buffer);

    // Save the QR code image to the gallery
    final result =
        await ImageGallerySaver.saveImage(Uint8List.fromList(buffer));
    if (result['isSuccess']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('QR code saved to gallery')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save QR code')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error saving QR code: $e')),
    );
  }
}

class QrCodeScreen {
  final String text;

  // Constructor
  QrCodeScreen({required this.text});

  // Method to create the QR code widget
  QrImageView buildQrCode() {
    return QrImageView(
      data: text,
      size: 200.0,
      backgroundColor: Colors.white,
    );
  }
}
