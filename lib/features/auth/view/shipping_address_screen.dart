import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/colors.dart';
import '../../../utils/contants.dart';
import '../controller/user_data_controller.dart';

class ShippingAddressScreen extends StatelessWidget {
  ShippingAddressScreen({super.key});
  static const routeName = 'shipping-screen';
  final _key = GlobalKey<FormState>();
  final UserDataController controller = Get.put(UserDataController());
  @override
  Widget build(BuildContext context) {
    controller.getUserData();
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "شپنگ ایڈریس",
          style: textStyle,
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(width * 0.06),
          child: Column(
            children: [
              SizedBox(
                height: height * 0.02,
              ),
              Image.asset(
                'assets/images/user_data.png',
                width: width * 0.5,
                height: height * 0.2,
              ),
              SizedBox(
                height: height * 0.05,
              ),
              TextFormField(
                controller: controller.addressController,
                keyboardType: TextInputType.streetAddress,
                validator: (value) {
                  if (value == null) {
                    return "ایڈریس ایک مطلوبہ فیلڈ ہے";
                  }
                  return null;
                },
                decoration: fieldStyle.copyWith(
                  hintText: 'پتہ',
                  hintStyle: textStyle.copyWith(
                      fontWeight: FontWeight.w400,
                      color: grayColor,
                      fontSize: height * 0.017),
                  prefixIcon: const Icon(Icons.navigation_sharp),
                ),
              ),
              SizedBox(
                height: height * 0.015,
              ),
              TextFormField(
                controller: controller.zipController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null) {
                    return "پوسٹ کوڈ ایک مطلوبہ فیلڈ ہے";
                  }
                  return null;
                },
                decoration: fieldStyle.copyWith(
                  hintText: 'پوسٹ کوڈ',
                  hintStyle: textStyle.copyWith(
                      fontWeight: FontWeight.w400,
                      color: grayColor,
                      fontSize: height * 0.017),
                  prefixIcon: const Icon(Icons.zoom_in_map),
                ),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_key.currentState!.validate()) {
                    controller.updateAddress(controller.addressController.text,
                        controller.zipController.text);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  fixedSize: Size(width * 0.88, height * 0.06),
                  // side: BorderSide()
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
                child: Text(
                  "محفوظ کریں",
                  style: textStyle.copyWith(
                      fontSize: height * 0.02, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
