import 'package:agritech/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const adminEmail = 'awais@agritech.com';
const List<String> orderEnum = ["processing", "completed", "cancelled"];
const List<String> productType = ['seed', 'tool', 'fertilizer'];
const List<String> userTypes = ['Customer', 'Company'];

final currentUserEmail = FirebaseAuth.instance.currentUser!.email;
final currentUserId = FirebaseAuth.instance.currentUser!.uid;
var authUser = FirebaseAuth.instance.currentUser!;
final fieldStyle = InputDecoration(
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Color(0xffBFBFBF), width: 1),
    borderRadius: BorderRadius.circular(5),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Color(0xffBFBFBF), width: 1),
    borderRadius: BorderRadius.circular(5),
  ),
);

final buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    // side: BorderSide()
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)));
const textStyle = TextStyle(
  color: Colors.black,
  fontFamily: 'sfui',
  fontWeight: FontWeight.w600,
);

const privacyPolicyText = """

Privacy Policy

Introduction

Welcome to AgriTech. This privacy policy outlines how we collect, use, and disclose your personal information when you visit our website, use our mobile app, or purchase our products or services.

Information We Collect

We collect the following types of personal information from you:

Personal information you provide us voluntarily: This includes information such as your name, email address, mailing address, phone number, and payment information. You may provide us with this information when you create an account, place an order, subscribe to our newsletter, or contact us for customer support.

Information we collect automatically: When you visit our website or use our mobile app, we may collect certain information automatically, such as your IP address, browser type, operating system, and browsing history. This information is used to help us improve our website and mobile app and to provide you with a better user experience.

Information from third parties: We may also collect information about you from other sources, such as public databases or marketing partners. This information may be used to supplement the information we collect from you directly.

How We Use Your Information

We use your personal information for the following purposes:

To fulfill your requests: We use your personal information to process your orders, create your account, provide you with customer support, and send you marketing communications.

To improve our website and mobile app: We use your personal information to analyze website traffic, improve our website and mobile app, and personalize your experience.

To comply with legal requirements: We may use your personal information to comply with applicable laws and regulations.

Disclosure of Your Information

We may disclose your personal information to the following third parties:

Service providers: We may disclose your personal information to service providers who help us operate our website and mobile app, such as payment processors, shipping companies, and email service providers.

Business partners: We may disclose your personal information to business partners with whom we collaborate to offer our products and services, such as marketing partners and product partners.

Legal authorities: We may disclose your personal information to legal authorities if required by law or if we believe that it is necessary to protect our rights or the rights of others.

Your Choices

You have the following choices regarding your personal information:

You can access and update your personal information: You can access and update your personal information by logging into your account or contacting us.

You can unsubscribe from marketing communications: You can unsubscribe from our marketing communications by clicking on the "unsubscribe" link in any marketing email that we send you.

You can request to delete your personal information: You can request to delete your personal information by contacting us.

Data Security

We take reasonable measures to protect your personal information from unauthorized access, use, disclosure, alteration, or destruction. These measures include using secure data storage and transmission methods, limiting access to your personal information, and training our employees on data security.

Changes to This Privacy Policy

We may update this privacy policy from time to time. We will notify you of any material changes by posting the updated privacy policy on our website.

Contact Us

If you have any questions about this privacy policy, please contact us at awais.ali10600@gmail.com

Effective Date:

This privacy policy is effective as of Dec 20,2026.


""";
