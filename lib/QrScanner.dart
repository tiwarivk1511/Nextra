import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_vcard_parser/simple_vcard_parser.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:wifi_iot/wifi_iot.dart';

import 'GenerateQrCode.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  File? _selectedImage;
  String _scannedData = '';

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final List<Permission> permissionsToRequest = [
      Permission.camera,
      Permission.storage,
    ];

    final Map<Permission, PermissionStatus> permissionStatus =
        await permissionsToRequest.request();

    if (permissionStatus[Permission.camera]!.isDenied ||
        permissionStatus[Permission.storage]!.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Camera and storage permissions are required for QR code scanning.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _getImageFromGallery() async {
    final XFile? pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;
    setState(() {
      _selectedImage = File(pickedImage.path);
      scanQRCode(_selectedImage!.path);
    });
  }

  void handleQRData(String data) {
    if (data.startsWith('http://') || data.startsWith('https://')) {
      openLink(data);
    } else if (data.startsWith('mailto:')) {
      sendEmail(data);
    } else if (data.startsWith('tel:')) {
      makePhoneCall(data);
    } else if (data.startsWith('sms:')) {
      sendSMS(
          data.substring(4), "Hello from Flutter!"); // Send SMS with message
    } else if (data.startsWith('BEGIN:VCARD')) {
      handleVCard(data);
    } else if (data.startsWith('whatsapp://')) {
      openWhatsApp(data);
    } else if (data.startsWith('WIFI:')) {
      connectToWiFi(data);
    } else if (data.startsWith('https://www.paypal.com/')) {
      openPayPal(data);
    } else if (data.startsWith('BEGIN:VEVENT')) {
      handleEvent(data);
    } else if (data.toLowerCase().endsWith('.pdf')) {
      openPDF(data);
    } else if (data.startsWith('market://')) {
      openAppInPlayStore(data);
    } else if (data.startsWith('https://play.google.com/store/apps/')) {
      openAppInPlayStore(data);
    } else if (data.startsWith('https://apps.apple.com/')) {
      openAppInAppStore(data);
    } else if (data.startsWith('geo:')) {
      openLocationInMaps(data);
    } else if (data.startsWith('smsto:')) {
      sendSMSToNumber(data);
    } else if (data.toLowerCase().endsWith('.jpg') ||
        data.toLowerCase().endsWith('.png')) {
      openImage(data);
    } else if (data.toLowerCase().endsWith('.mp4') ||
        data.toLowerCase().endsWith('.mov')) {
      openVideo(data);
    } else if (data.toLowerCase().contains('facebook.com') ||
        data.toLowerCase().contains('twitter.com')) {
      openSocialMedia(data);
    } else {
      showUnsupportedDataTypeMessage();
    }
  }

  void openLink(String url) {
    launch(Uri.parse(url) as String);
  }

  void sendEmail(String email) {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': 'Email subject',
        'body': 'Email body',
      },
    );
    launch(emailUri.toString());
  }

  void makePhoneCall(String phoneNumber) {
    launch('tel:$phoneNumber');
  }

  void sendSMS(String phoneNumber, String message) async {
    final Uri uri = Uri.parse('sms:$phoneNumber?body=$message');

    try {
      if (await canLaunch(uri.toString())) {
        await launch(uri.toString());
      } else {
        print('Failed to launch SMS app');
      }
    } catch (e) {
      print('Error launching SMS app: $e');
    }
  }

  void handleVCard(String vCardData) {
    try {
      VCard vCard = VCard(vCardData);
      String name = vCard.name.toString();
      String email = vCard.typedEmail[0].value;
      String phone = vCard.typedTelephone[0].value;
      String address = vCard.typedAddress[0].value;
      String url = vCard.typedURL[0].value;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('VCard Details'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Name: $name'),
                Text('Email: $email'),
                Text('Phone: $phone'),
                Text('Address: $address'),
                Text('URL: $url'),
              ],
            ),
          );
        },
      );
    } catch (e) {
      print('Error parsing vCard: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to parse vCard data.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void openWhatsApp(String phoneNumber) {
    launch('https://api.whatsapp.com/send?phone=$phoneNumber');
  }

  void connectToWiFi(String wifiData) async {
    WiFiForIoTPlugin.connect(wifiData);
  }

  void openPayPal(String url) async {
    // Check if the PayPal app is installed
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // If PayPal app is not installed, provide fallback action
      // For example, you can launch PayPal website or show a message
      launch('https://www.paypal.com/');
    }
  }

  void handleEvent(String eventData) {
    var eventDataList = eventData.split(':');
    var eventType = eventDataList[0];
    var eventDetails = eventDataList[1];
    // Handle event data
  }

  void openPDF(String pdfLink) {
    launch(Uri.encodeFull(pdfLink),
        forceSafariVC: false, universalLinksOnly: false);
  }

  void openAppInPlayStore(String appLink) {
    launch(
        Uri.encodeFull(
            'https://play.google.com/store/apps/details?id=$appLink'),
        forceSafariVC: false,
        universalLinksOnly: false);
  }

  void openAppInAppStore(String appLink) {
    launch(Uri.encodeFull('https://itunes.apple.com/app/id$appLink'),
        forceSafariVC: false, universalLinksOnly: false);
  }

  void openLocationInMaps(String locationData) {
    final Uri mapsUri =
        Uri.parse('https://maps.google.com/maps?q=$locationData');
    launch(mapsUri.toString());
  }

  void sendSMSToNumber(String smsData) {
    final Uri smsUri = Uri.parse('sms:${smsData.replaceFirst('smsto:', '')}');
    launch(smsUri.toString());
  }

  void openImage(String imageUrl) {
    launch(imageUrl);
  }

  void openVideo(String url) async {
    VideoPlayerController videoPlayerController =
        VideoPlayerController.network(url);
    await videoPlayerController.initialize();
    await showModalBottomSheet(
        context: context,
        builder: (context) => VideoPlayer(videoPlayerController));
    videoPlayerController.dispose();
  }

  void openSocialMedia(String socialMediaLink) {
    launch(socialMediaLink);
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
      showUnsupportedDataTypeMessage() {
    return ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Unsupported data type. Please try again with a different QR code.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
      appBar: AppBar(
        title: const Text(
          'QR Scanner',
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        _scannedData.isNotEmpty
                            ? _scannedData
                            : 'Scanned data will appear here',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _scanQRCodeFromCamera(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(255, 255, 255, 1),
                              foregroundColor:
                                  const Color.fromRGBO(32, 29, 43, 1),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            icon: const Icon(Icons.qr_code_scanner,
                                color: Color.fromRGBO(32, 29, 43, 1)),
                            label: const Text(
                              'Scan QR \ncode',
                              style: TextStyle(
                                color: Color.fromRGBO(32, 29, 43, 1),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton.icon(
                            onPressed: _getImageFromGallery,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(255, 255, 255, 1),
                              foregroundColor:
                                  const Color.fromRGBO(32, 29, 43, 1),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            icon: const Icon(Icons.image_outlined,
                                color: Color.fromRGBO(32, 29, 43, 1)),
                            label: const Text(
                              'Scan QR code from\ngallery',
                              style: TextStyle(
                                color: Color.fromRGBO(32, 29, 43, 1),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const GenerateQR(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(255, 255, 255, 1),
                          foregroundColor: const Color.fromRGBO(32, 29, 43, 1),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.qr_code_2_outlined,
                            color: Color.fromRGBO(32, 29, 43, 1)),
                        label: const Text(
                          'Generate QR code',
                          style: TextStyle(
                            color: Color.fromRGBO(32, 29, 43, 1),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (_selectedImage != null) Image.file(_selectedImage!),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _scanQRCodeFromCamera() async {
    try {
      final String result = await FlutterBarcodeScanner.scanBarcode(
          '#FF6666', 'Cancel', true, ScanMode.QR);
      if (!mounted) return;
      setState(() {
        _scannedData = result.toString();
      });
      handleQRData(result);
    } catch (e) {
      print('Error scanning QR code from camera: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to scan QR code from camera.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> scanQRCode(String imagePath) async {
    try {
      final String result = imagePath;
      if (!mounted) return;
      setState(() {
        _scannedData = result.toString();
      });
      handleQRData(result);
    } on PlatformException {
      setState(() {
        _scannedData = 'Failed to get platform version.';
      });
    }
  }
}
