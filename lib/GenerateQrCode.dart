import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';

class GenerateQR extends StatefulWidget {
  const GenerateQR({super.key});

  @override
  _GenerateQRState createState() => _GenerateQRState();
}

class _GenerateQRState extends State<GenerateQR> {
  TextEditingController textController = TextEditingController();

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
                  TextField(
                    controller: textController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Enter text to generate QR code',
                      hintStyle: TextStyle(color: Colors.blueGrey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        gapPadding: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (textController.text.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content:
                              Text('Please enter text to generate QR code.'),
                        ));
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              GeneratedQrCodeScreen(text: textController.text),
                        ));
                      }
                    },
                    icon: const Icon(Icons.qr_code_2_rounded),
                    label: const Text('Generate QR'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.deepPurple,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 20),
                  Text(
                    textController.text,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
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

  const GeneratedQrCodeScreen({super.key, required this.text});

  Future<void> _shareQrCode(BuildContext context, String text) async {
    try {
      final directory = (await getApplicationDocumentsDirectory()).path;
      final filePath = '$directory/qr_code.png';

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
      final image =
          await painter.toImageData(2048, format: ImageByteFormat.png);
      final buffer = image!.buffer.asUint8List();
      final file = File(filePath);
      await file.writeAsBytes(buffer);

      // Share the QR code
      await Share.shareFiles([filePath], text: 'Check out this QR code!');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing QR code: $e')),
      );
    }
  }

  Future<void> _saveQrCode(BuildContext context, String text) async {
    try {
      final directory = (await getApplicationDocumentsDirectory()).path;
      final filePath = '$directory/qr_code.png';

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
      final image =
          await painter.toImageData(2048, format: ImageByteFormat.png);
      final buffer = image!.buffer.asUint8List();
      final file = File(filePath);
      await file.writeAsBytes(buffer);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('QR code saved to documents folder')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving QR code: $e')),
      );
    }
  }

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
        title: const Text(
          'Your Generated QR Code',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
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
                      onPressed: () => _shareQrCode(context, text),
                      child: const Text('Share QR'),
                    ),
                    ElevatedButton(
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
