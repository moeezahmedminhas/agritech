import 'package:agritech/features/home/views/home_screen.dart';
import 'package:agritech/utils/contants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/colors.dart';
import '../controller/user_data_controller.dart';

class UserDataScreen extends StatelessWidget {
  static const routeName = '/user-data-screen';

  UserDataScreen({super.key});
  final _key = GlobalKey<FormState>();
  final UserDataController controller = Get.put(UserDataController());
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "ذاتی معلومات",
          style: textStyle,
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Padding(
            padding: EdgeInsets.all(width * 0.06),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
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
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "آپ کی معلومات سے ہماری خدمات کو آسانی سے پہنچنے میں مدد ملے گی",
                    style: textStyle.copyWith(
                        fontSize: height * 0.022,
                        fontWeight: FontWeight.w400,
                        color: grayColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: height * 0.06,
                ),
                TextFormField(
                  controller: controller.nameController,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null) {
                      return "پورا نام ایک مطلوبہ فیلڈ ہے";
                    }
                    return null;
                  },
                  decoration: fieldStyle.copyWith(
                    hintText: 'پورا نام',
                    hintStyle: textStyle.copyWith(
                        fontWeight: FontWeight.w400,
                        color: grayColor,
                        fontSize: height * 0.017),
                    prefixIcon: const Icon(Icons.person),
                  ),
                ),
                SizedBox(
                  height: height * 0.015,
                ),
                TextFormField(
                  controller: controller.addressController,
                  keyboardType: TextInputType.streetAddress,
                  validator: (value) {
                    if (value == null) {
                      return "پتہ ایک مطلوبہ فیلڈ ہے";
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
                  height: height * 0.015,
                ),
                TextFormField(
                  controller: controller.phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null) {
                      return "فون نمبر ایک مطلوبہ فیلڈ ہے";
                    }
                    return null;
                  },
                  decoration: fieldStyle.copyWith(
                    hintText: 'فون نمبر',
                    hintStyle: textStyle.copyWith(
                        fontWeight: FontWeight.w400,
                        color: grayColor,
                        fontSize: height * 0.017),
                    prefixIcon: const Icon(Icons.phone),
                  ),
                ),
                SizedBox(
                  height: height * 0.015,
                ),
                DropdownButtonFormField(
                  validator: (value) {
                    if (value == null) {
                      return 'زمرہ درکار ہے';
                    }
                    return null;
                  },
                  decoration: fieldStyle.copyWith(
                      focusColor: Colors.white,
                      fillColor: Colors.white,
                      hintText: 'صارف کی قسم'),
                  items: userTypes.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      controller.userTypeController.text = val;
                    }
                  },
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_key.currentState!.validate()) {
                      controller.saveUserDataToFirebase(
                          controller.nameController.text,
                          controller.addressController.text,
                          controller.zipController.text,
                          controller.phoneController.text,
                          controller.userTypeController.text);

                      Get.offAll(() => const HomeScreen());
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
      ),
    );
  }
}
