import 'package:agritech/utils/contants.dart';
import 'package:flutter/material.dart';

class PaymentMethods extends StatelessWidget {
  const PaymentMethods({super.key});
  static const routeName = '/payment-methods';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "ادائیگی کے طریقے",
          style: textStyle,
        ),
        backgroundColor: Colors.white,
      ),
      body: const Center(
          child: Text(
        'ادائیگی کا موجودہ طریقہ کیش آن ڈیلیوری ہے',
        style: textStyle,
      )),
    );
  }
}
