import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TermsCondition extends StatefulWidget {
  const TermsCondition({super.key});

  @override
  _TermsConditionState createState() => _TermsConditionState();
}

class _TermsConditionState extends State<TermsCondition> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'Terms & Conditions',
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
              'These Terms & Conditions ("Terms") govern your use of the Nextra ("App") developed by Vikash Tiwari & Team. By downloading, installing, or using the App, you agree to be bound by these Terms.'
              'If you disagree with any part of these Terms, you may not use the App.',
        ),
        _buildTermItem(
          title: '2. Use of the App',
          content:
              'You must be at least 18 years old or of legal age to enter into a contract to use the App.\nYou are solely responsible for your use of the App and any consequences thereof.\nYou will not use the App for any illegal or unauthorized purpose.\nYou will not modify, reverse engineer, decompile, disassemble, or attempt to discover the source code of the App.\nYou will not transmit any viruses, malware, or other harmful code through the App',
        ),
        _buildTermItem(
          title: '3. Content',
          content:
              'The App may contain content provided by us or by third parties. We do not control or endorse all content, and we are not responsible for its accuracy, completeness, or legality.',
        ),
        _buildTermItem(
          title: '4. Intellectual Property',
          content:
              'The App and all its content, including but not limited to text, graphics, logos, icons, images, and software, are the property of Vikash Tiwari & Team or its licensors and are protected by copyright, trademark, and other intellectual property laws.',
        ),
        _buildTermItem(
          title: '5. Disclaimer of Warranties',
          content:
              'THE APP IS PROVIDED "AS IS" AND WITHOUT WARRANTIES OF ANY KIND, WHETHER EXPRESS OR IMPLIED. WE DISCLAIM ALL WARRANTIES, INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND NON-INFRINGEMENT.',
        ),
        _buildTermItem(
          title: '6. Limitation of Liability',
          content:
              'WE WILL NOT BE LIABLE FOR ANY DAMAGES ARISING OUT OF OR RELATED TO YOUR USE OF THE APP, INCLUDING BUT NOT LIMITED TO DIRECT, INDIRECT, INCIDENTAL, SPECIAL, CONSEQUENTIAL, OR PUNITIVE DAMAGES.',
        ),
        _buildTermItem(
          title: '7. Termination',
          content:
              'We may terminate your access to the App at any time for any reason.',
        ),
        _buildTermItem(
          title: '8. Governing Law',
          content:
              'These Terms will be governed by and construed in accordance with the laws of India 🇮🇳.',
        ),
        _buildTermItem(
          title: '9. Dispute Resolution',
          content:
              'Any dispute arising out of or relating to these Terms will be subject to the exclusive jurisdiction of the courts located in India 🇮🇳.',
        ),
        _buildTermItem(
          title: '10. Entire Agreement',
          content:
              'These Terms constitute the entire agreement between you and us regarding your use of the App.',
        ),
        _buildTermItem(
          title: '11. Updates to the Terms',
          content:
              'We may update these Terms from time to time by posting a new version on the App. Your continued use of the App after the posting of any updated Terms constitutes your acceptance of such updates.',
        ),
        _buildTermItem(
          title: '12. Contact Us',
          content:
              'If you have any questions about these Terms, please contact us.',
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
