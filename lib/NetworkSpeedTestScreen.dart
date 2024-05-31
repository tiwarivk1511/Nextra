import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_internet_speed_test/flutter_internet_speed_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class NetworkSpeedTest extends StatefulWidget {
  const NetworkSpeedTest({super.key});

  @override
  _NetworkSpeedTestState createState() => _NetworkSpeedTestState();
}

class _NetworkSpeedTestState extends State<NetworkSpeedTest> {
  double displayProgress = 0.0;
  double _downloadRate = 0.0;
  double _uploadRate = 0.0;
  double displayRate = 0.0;

  bool isServiceSelectionInProgress = false;
  bool isTestingStarted = false;

  String serviceType = '';
  String? IPAddress;
  String? ISP;
  String? ASN;

  String unitType = '';

  //create a function to display the network type is WIFI or cellular

  String _getNetworkType(String networkType) {
    if (networkType == 'wifi') {
      return 'WIFI';
    } else {
      return 'Cellular';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
      appBar: AppBar(
        title: const Text(
          'Network Speed Test',
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
            Navigator.of(context).pop(); // Navigate back to previous screen
          },
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset(
            'assets/background.svg', // Replace 'background.svg' with the path to your SVG file
            fit: BoxFit.cover,
          ),
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            color: const Color.fromARGB(1, 32, 29, 43)
                .withOpacity(0.9), // Adjust opacity as needed
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 4,
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 5,
                          sigmaY: 5,
                        ), // Adjust the sigmaX and sigmaY values for the desired blur effect
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(
                                0.1), // Adjust the opacity as needed
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              // Add Network Speed meter with a dynamic needle to represent the speed of network
                              SfRadialGauge(
                                axes: [
                                  RadialAxis(
                                    radiusFactor: 0.85,
                                    minorTicksPerInterval: 1,
                                    tickOffset: 3,
                                    useRangeColorForAxis: true,
                                    interval: 10,
                                    minimum: 0,
                                    maximum: 100,
                                    canScaleToFit: true,
                                    showLastLabel: true,
                                    axisLabelStyle: const GaugeTextStyle(
                                      color: Colors.white,
                                    ),
                                    ranges: [
                                      GaugeRange(
                                        color: Colors.cyanAccent,
                                        startValue: 0,
                                        endValue: displayRate,
                                        startWidth: 10,
                                        endWidth: 10,
                                      ),
                                    ],
                                    pointers: [
                                      NeedlePointer(
                                        value: displayRate,
                                        enableAnimation: true,
                                        animationDuration:
                                            1200, // Animation duration in milliseconds
                                        needleColor: Colors.deepPurpleAccent,
                                        tailStyle: const TailStyle(
                                          borderWidth: 0.5,
                                          borderColor: Colors.cyanAccent,
                                        ),
                                        knobStyle: const KnobStyle(
                                          borderColor: Colors.cyanAccent,
                                          color: Colors.deepPurpleAccent,
                                        ),
                                      ),
                                    ],
                                    annotations: [
                                      GaugeAnnotation(
                                        widget: Container(
                                          child: Text(
                                            '$displayRate' + unitType,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        angle: 90,
                                        positionFactor: 0.8,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                isServiceSelectionInProgress
                                    ? 'Selecting Server....'
                                    : 'IP: ${IPAddress ?? "--"} | ISP: ${ISP ?? "--"} | ASN: ${ASN ?? "--"}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  testingFunction();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 23, 243, 255),
                                ),
                                child: const Text(
                                  "Start Network Test",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Progress",
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: displayProgress / 100,
                    color: Colors.blue,
                    backgroundColor: Colors.blueGrey.shade300,
                    minHeight: 10,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.blue),
                    semanticsLabel: 'Linear progress indicator',
                    borderRadius: BorderRadius.circular(10),
                  ),
                  Text(
                    displayProgress.toStringAsFixed(2) + '%',
                    style: const TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    color: const Color.fromRGBO(55, 38, 63, 1).withOpacity(0.1),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 5,
                          sigmaY: 5,
                        ), // Adjust the sigmaX and sigmaY values for the desired blur effect
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(
                              0.1,
                            ), // Adjust the opacity as needed
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Add Network Speed Test Results here like Ping, Download Speed, Upload Speed
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Add Network Speed Test Results here like Ping, Download Speed, Upload Speed with their corresponding values by using separate columns for each
                                  Column(
                                    children: [
                                      const Text(
                                        'Download Speed:',
                                        style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        '${_downloadRate.toStringAsFixed(2)}' +
                                            unitType,
                                        style: const TextStyle(
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Text(
                                        'Upload Speed:',
                                        style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        _uploadRate.toStringAsFixed(2) +
                                            unitType,
                                        style: const TextStyle(
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  testingFunction() async {
    // Start testing
    final speedTest = FlutterInternetSpeedTest();

    try {
      await speedTest.startTesting(
        onStarted: () {
          setState(() {
            isTestingStarted = true;
          });
        },
        onCompleted: (TestResult download, TestResult upload) {
          setState(() {
            unitType = download.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
            _downloadRate = download.transferRate;
            _uploadRate = upload.transferRate;
            displayRate = 0.00;
            displayProgress = 100.0;
            isTestingStarted = false;
          });
          setState(() {
            unitType = upload.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
            _uploadRate = upload.transferRate;
            displayProgress = 100.0;
            displayRate = 0.00;
            isTestingStarted = false;
          });
        },
        onProgress: (double percent, TestResult data) {
          setState(() {
            if (data.type == TestType.download) {
              _downloadRate = data.transferRate;
              displayRate = data.transferRate;
            } else if (data.type == TestType.upload) {
              _uploadRate = data.transferRate;
              displayRate = data.transferRate;
            }
            displayProgress = percent;
          });
        },
        onError: (String errorMessage, String speedTestError) {
          print('Error: $errorMessage' ' $speedTestError');
          setState(() {
            isTestingStarted = false;
          });
        },
        onDefaultServerSelectionInProgress: () {
          setState(() {
            isServiceSelectionInProgress = true;
          });
        },
        onDefaultServerSelectionDone: (Client? client) {
          setState(() {
            isServiceSelectionInProgress = false;
            if (client != null) {
              IPAddress = client.ip;
              ASN = client.asn;
              ISP = client.isp;
            }
          });
        },
        onDownloadComplete: (TestResult data) {
          setState(() {
            _downloadRate = data.transferRate;
          });
        },
        onUploadComplete: (TestResult data) {
          setState(() {
            _uploadRate = data.transferRate;
          });
        },
      );
    } catch (e) {
      print('Error occurred during testing: $e');
    }
  }
}
