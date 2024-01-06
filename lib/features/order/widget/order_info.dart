import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/colors.dart';
import '../../../utils/contants.dart';

class OrderInfoWidget extends StatelessWidget {
  final String text;
  final String value;
  final double fontSize;
  const OrderInfoWidget(
      {super.key,
      required this.text,
      required this.value,
      this.fontSize = 0.016});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value,
          style: textStyle.copyWith(
            color: grayColor,
            fontWeight: FontWeight.w500,
            fontSize: Get.height * fontSize,
          ),
          textAlign: TextAlign.justify,
        ),
        Text(
          text,
          style: textStyle.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: Get.height * fontSize,
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }
}
