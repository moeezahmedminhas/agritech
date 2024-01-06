import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/contants.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});
  static const routeName = '/privacy-policy';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "رازداری کی پالیسی",
          style: textStyle,
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Get.width * 0.03),
          child: Text(
            privacyPolicyText, // Replace this placeholder with the actual privacy policy text
            style: TextStyle(fontSize: Get.height * 0.015),
          ),
        ),
      ),
    );
  }
}
