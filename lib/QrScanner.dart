import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:video_player/video_player.dart';
import 'package:simple_vcard_parser/simple_vcard_parser.dart';

import 'GenerateQrCode.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({Key? key}) : super(key: key);

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
      // Open a web link
      openLink(data);
    } else if (data.startsWith('mailto:')) {
      // Send an email
      sendEmail(data);
    } else if (data.startsWith('tel:')) {
      // Make a phone call
      makePhoneCall(data);
    } else if (data.startsWith('sms:')) {
      // Send an SMS
      sendSMS(data);
    } else if (data.startsWith('BEGIN:VCARD')) {
      // Handle vCard
      handleVCard(data);
    } else if (data.startsWith('whatsapp://')) {
      // Open WhatsApp
      openWhatsApp(data);
    } else if (data.startsWith('WIFI:')) {
      // Connect to Wi-Fi
      connectToWiFi(data);
    } else if (data.startsWith('https://www.paypal.com/')) {
      // Open PayPal link
      openPayPal(data);
    } else if (data.startsWith('BEGIN:VEVENT')) {
      // Handle event data
      handleEvent(data);
    } else if (data.toLowerCase().endsWith('.pdf')) {
      // Open PDF file
      openPDF(data);
    } else if (data.startsWith('market://')) {
      // Open app in Play Store
      openAppInPlayStore(data);
    } else if (data.startsWith('https://play.google.com/store/apps/')) {
      // Open app in Play Store
      openAppInPlayStore(data);
    } else if (data.startsWith('https://apps.apple.com/')) {
      // Open app in App Store
      openAppInAppStore(data);
    } else if (data.startsWith('geo:')) {
      // Open location in Maps
      openLocationInMaps(data);
    } else if (data.startsWith('smsto:')) {
      // Send SMS to number
      sendSMSToNumber(data);
    } else if (data.toLowerCase().endsWith('.jpg') ||
        data.toLowerCase().endsWith('.png')) {
      // Open image
      openImage(data);
    } else if (data.toLowerCase().endsWith('.mp4') ||
        data.toLowerCase().endsWith('.mov')) {
      // Open video
      openVideo(data);
    } else if (data.toLowerCase().contains('facebook.com') ||
        data.toLowerCase().contains('twitter.com')) {
      // Open social media link
      openSocialMedia(data);
    } else {
      // Unsupported data type
      showUnsupportedDataTypeMessage();
    }
  }

  void openLink(String url) {
    // Implement logic to open web link
    launch(Uri.parse(url) as String);
  }

  void sendEmail(String email) {
    // Implement logic to send email

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
    // Implement logic to make phone call
  }

  void sendSMS(String phoneNumber) {
    // Implement logic to send SMS
  }

  void handleVCard(String vCardData) {
    try {
      VCard vCard = VCard(vCardData);
      String name = vCard.name.toString();
      String email = vCard.typedEmail[0].value;
      String phone = vCard.typedTelephone[0].value;
      String address = vCard.typedAddress[0].value;
      String url = vCard.typedURL[0].value;

      // Show all details in a dialog with a button to copy to clipboard & a call button
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('VCard Details'),
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
            title: Text('Error'),
            content: Text('Failed to parse vCard data.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void openWhatsApp(String phoneNumber) {
    // Implement logic to open WhatsApp
    String url = 'https://api.whatsapp.com/send?phone=$phoneNumber';
  }

  void connectToWiFi(String wifiData) async {
    WiFiForIoTPlugin.connect(wifiData);
  }


  void openPayPal(String UPILink) {
    // Implement logic to open UPI link
    launch(UPILink);
  }

  void handleEvent(String eventData) {
    // Implement logic to handle event data
    var eventDataList = eventData.split(':');
    var eventType = eventDataList[0];
    var eventDetails = eventDataList[1];

  }

  void openPDF(String pdfLink) {
    // Implement logic to open PDF file
    launch(Uri.encodeFull(pdfLink), forceSafariVC: false, universalLinksOnly: false);
  }

  void openAppInPlayStore(String appLink) {
    // Implement logic to open app in Play Store
    launch(Uri.encodeFull('https://play.google.com/store/apps/details?id=$appLink'), forceSafariVC: false, universalLinksOnly: false);
  }

  void openAppInAppStore(String appLink) {
    // Implement logic to open app in App Store
    launch(Uri.encodeFull('https://itunes.apple.com/app/id$appLink'), forceSafariVC: false, universalLinksOnly: false);
  }

  void openLocationInMaps(String locationData) {
    // Implement logic to open location in Maps
    final Uri mapsUri = Uri.parse('https://maps.google.com/maps?q=$locationData');
  }

  void sendSMSToNumber(String smsData) {
    // Implement logic to send SMS to number
    final Uri smsUri = Uri.parse('sms:${smsData.replaceFirst('smsto:', '')}');
    launch(smsUri.toString());
  }

  void openImage(String imageUrl) {
    // Implement logic to open image
    launch(imageUrl);
  }


    // Implement logic to open video
  void openVideo(String url) async {
    VideoPlayerController videoPlayerController = VideoPlayerController.network(url);
    await videoPlayerController.initialize();
    await showModalBottomSheet(
      context: context,
      builder: (context) => VideoPlayer(videoPlayerController)
    );
    videoPlayerController.dispose();
    }

  void openSocialMedia(String socialMediaLink) {
    // Implement logic to open social media link
    launch(socialMediaLink);
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showUnsupportedDataTypeMessage() {
    // Implement logic to show message for unsupported data type
    return ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Unsupported data type. Please try again with a different QR code.',
        )
      )
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
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40,
                    child: Text(
                      _scannedData.isNotEmpty
                          ? _scannedData
                          : 'Scanned data will appear here',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Your QR scanner UI components here
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _scanQRCodeFromCamera(),
                        label: Text('Scan QR code'),
                        icon: Icon(Icons.qr_code_scanner),
                      ),
                      ElevatedButton.icon(
                        onPressed: _getImageFromGallery,
                        label: Text('Scan QR code\nfrom gallery'),
                        icon: Icon(Icons.image_outlined),
                      ),
                    ],
                  ),

                  ElevatedButton.icon(
                    onPressed: () =>  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const GenerateQR(),
                    )),
                      icon: Icon(Icons.qr_code_2_outlined),
                    label: Text('Generate QR code'),
                  ),
                  SizedBox(height: 20),
                  // Display the selected image if needed
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
      final String result = await FlutterBarcodeScanner.scanBarcode('#FF6666', 'Cancel', true, ScanMode.QR);
      if(!mounted) return;
      setState(() {
        this._scannedData = result.toString();
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

  //scan code logic
  Future<void> scanQR() async{
    // try {
    //   final String result = await FlutterBarcodeScanner.scanBarcode('#FF6666', 'Cancel', true, ScanMode.QR);
    //   if(!mounted) return;
    //   setState(() {
    //     this._scannedData = result.toString();
    //   });
    // }on PlatformException {
    //   setState(() {
    //     this._scannedData = 'Failed to get platform version.';
    //   });
    // }
  }

  Future<void> scanQRCode(String ImagePath) async{
    try {
      final String result = ImagePath;
      if(!mounted) return;
      setState(() {
        this._scannedData = result.toString();
      });
    }on PlatformException {
      setState(() {
        this._scannedData = 'Failed to get platform version.';
      });
    }
  }



}
