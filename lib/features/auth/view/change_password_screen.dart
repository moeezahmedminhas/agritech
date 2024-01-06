import 'package:agritech/features/auth/controller/user_data_controller.dart';
import 'package:agritech/utils/colors.dart';
import 'package:agritech/utils/contants.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});
  static const routeName = '/change-password-screen';

  final _key = GlobalKey<FormState>();
  final UserDataController controller = Get.put(UserDataController());
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    controller.confirmPasswordController.text = '';
    controller.newPasswordController.text = '';
    controller.currentPasswordController.text = '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "پاس ورڈ تبدیل کریں",
          style: textStyle,
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Padding(
            padding: EdgeInsets.all(width * 0.06),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.asset(
                'assets/images/login.png',
                width: width * 0.6,
                height: height * 0.3,
              ),
              SizedBox(
                height: width * 0.08,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Change Password",
                  style: textStyle.copyWith(
                    fontSize: height * 0.035,
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Obx(
                () => TextFormField(
                  controller: controller.currentPasswordController,
                  obscureText: controller.currentPassVisibility.value,
                  validator: (value) {
                    if (value == null) {
                      return 'موجودہ پاس ورڈ کی ضرورت ہے';
                    } else if (value.length < 6) {
                      return 'برائے مہربانی صحیح پاسورڈ درج کریں';
                    }
                    return null;
                  },
                  decoration: fieldStyle.copyWith(
                    hintText: 'موجودہ خفیہ لفظ',
                    hintStyle: textStyle.copyWith(
                        fontWeight: FontWeight.w400,
                        color: grayColor,
                        fontSize: height * 0.017),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.currentPassVisibility.value =
                            !controller.currentPassVisibility.value;
                      },
                      icon: Icon(controller.currentPassVisibility.value
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.015,
              ),
              Obx(
                () => TextFormField(
                  controller: controller.newPasswordController,
                  obscureText: controller.passVisibility.value,
                  validator: (value) {
                    if (value == null) {
                      return 'نیا پاس ورڈ درکار ہے';
                    } else if (value.length < 6) {
                      return 'برائے مہربانی صحیح پاسورڈ درج کریں';
                    }
                    return null;
                  },
                  decoration: fieldStyle.copyWith(
                    hintText: 'نیا پاس ورڈ',
                    hintStyle: textStyle.copyWith(
                        fontWeight: FontWeight.w400,
                        color: grayColor,
                        fontSize: height * 0.017),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.passVisibility.value =
                            !controller.passVisibility.value;
                      },
                      icon: Icon(controller.passVisibility.value
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.015,
              ),
              Obx(
                () => TextFormField(
                  controller: controller.confirmPasswordController,
                  obscureText: controller.passVisibility.value,
                  validator: (value) {
                    if (value == null) {
                      return 'پاس ورڈ کی تصدیق کی ضرورت ہے';
                    } else if (value.length < 6) {
                      return 'برائے مہربانی صحیح پاسورڈ درج کریں';
                    } else if (controller.confirmPasswordController.text !=
                        controller.newPasswordController.text) {
                      return 'تصدیق کریں کہ پاس ورڈ مماثل نہیں ہے';
                    }
                    return null;
                  },
                  decoration: fieldStyle.copyWith(
                    hintText: 'پاس ورڈ کی تصدیق کریں',
                    hintStyle: textStyle.copyWith(
                        fontWeight: FontWeight.w400,
                        color: grayColor,
                        fontSize: height * 0.017),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.passVisibility.value =
                            !controller.passVisibility.value;
                      },
                      icon: Icon(controller.passVisibility.value
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_key.currentState!.validate()) {
                    controller.changePassword(context);
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
                  "پاس ورڈ تبدیل کریں",
                  style: textStyle.copyWith(
                      fontSize: height * 0.02, color: Colors.white),
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
