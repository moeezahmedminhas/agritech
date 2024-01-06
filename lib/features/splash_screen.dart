import 'package:agritech/utils/contants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            // decoration: const BoxDecoration(
            //   shape: BoxShape.circle,
            //   color: Colors.green,
            // ),
            borderRadius: BorderRadius.circular(Get.height * 0.5),
            child: Image.asset(
              "assets/images/logo.png",
              width: Get.width * 0.6,
            ),
          ),
          SizedBox(
            height: Get.height * 0.05,
          ),
          const Text(
            "کسانوں کے لیے ایک ٹیک اسٹور",
            style: textStyle,
          ),
        ],
      )),
    );
  }
}
