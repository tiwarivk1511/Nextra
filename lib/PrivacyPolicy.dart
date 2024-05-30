import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'Privacy & Policy',
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
            'assets/background.svg',
            fit: BoxFit.cover,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withOpacity(0.5),
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                        height: 100,
                        width: double.maxFinite,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage('assets/logo.png'),
                                width: 80, height: 80,),
                              SizedBox(width: 10),
                              Text(
                                  'Nextra',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  )
                              )
                            ]
                        )

                    ),
                    const SizedBox(height: 20),
                    _buildTermsList(),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Add functionality to redirect to customer support here
                        // For example:
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => CustomerSupportScreen(),
                        //   ),
                        // );
                      },
                      child: const Text('Contact Us'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper functions for building the terms list items
  Widget _buildTermsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTermItem(
          title: '1. Introduction',
          content:
          'This Privacy Policy describes how we collects, uses, and discloses your information when you use the Nextra("App").',
        ),
        _buildTermItem(
          title: '2. Information We Collect',
          content:
          'We collect the following information when you use the App:\n\n'
              '- Personal Information: This may include your name, email address, and other information that you voluntarily provide to us when you use certain features of the App, such as chat with the bot or search by image. We only collect personal information that is necessary to provide you with those features.\n\n'
              '- Usage Data: This may include information about your use of the App, such as the features you access, the searches you perform (including uploaded images for search), the chat history with the bot, and the time you spend using the App. We collect usage data to improve the App, personalize your experience, and monitor for any suspected activity or illegal uses.\n\n'
              '- Device Information: This may include information about your device, such as your device model, operating system version, and unique device identifier. We collect device information to provide you with the best possible experience using the App.',
        ),
        _buildTermItem(
          title: '3. How We Use Your Information',
          content:
          'We use your information to:\n\n'
              '- Provide you with the features and functionality of the App\n\n'
              '- Improve the App\n\n'
              '- Personalize your experience\n\n'
              '- Communicate with you\n\n'
              '- Send you marketing communications (with your consent)\n\n'
              '- Analyze how the App is being used\n\n'
              '- Monitor for any suspected activity or illegal uses (limited to usage data)',
        ),
        _buildTermItem(
          title: '4. Disclosure of Your Information',
          content:
          'We may disclose your information to third-party service providers who help us operate the App. We will only disclose your information to service providers who agree to protect your information in accordance with this Privacy Policy.\n\n'
              'We may also disclose your information if we are required to do so by law or in the good faith belief that such disclosure is necessary to protect our rights or the rights of others.',
        ),
        _buildTermItem(
          title: '5. Text Recognition (OCR) Feature',
          content:
          'The App may use Google ML Kit for on-device text recognition when you use the OCR feature. Google ML Kit processes text data entirely on your device and does not transmit the text data to Google\'s servers.',
        ),
        _buildTermItem(
          title: '6. Security',
          content:
          'We take reasonable steps to protect your information from unauthorized access, disclosure, alteration, or destruction. However, no internet transmission or electronic storage is 100% secure.',
        ),
        _buildTermItem(
          title: '7. Children\'s Privacy',
          content:
          'The App is not directed to children under the age of 18. We do not knowingly collect personal information from children under 18.',
        ),
        _buildTermItem(
          title: '8. Data Retention',
          content:
          'We will retain your information for as long as necessary to provide you with the features and functionality of the App, to comply with our legal obligations, or to monitor for any suspected activity or illegal uses (limited to usage data).',
        ),
        _buildTermItem(
          title: '9. Your Choices',
          content:
          'You can choose not to receive marketing communications from us by following the unsubscribe instructions in those communications.\n\n'
              'You can also control your device permissions for camera and storage access in your device settings.',
        ),
        _buildTermItem(
          title: '10. Changes to this Privacy Policy',
          content:
          'We may update this Privacy Policy from time to time by posting a new version on the App. Your continued use of the App after the posting of any updated Privacy Policy constitutes your acceptance of such updates.',
        ),
        _buildTermItem(
          title: '11. Contact Us',
          content:
          'If you have any questions about this Privacy Policy, please contact us via our support team member.\n\n'
              'This Privacy Policy is compliant with Indian laws, including the Information Technology Act, 2000 and its amendments.',
        ),
      ],
    );
  }

  Widget _buildTermItem({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          content,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
