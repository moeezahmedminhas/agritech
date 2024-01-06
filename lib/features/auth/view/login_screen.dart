import 'package:agritech/utils/colors.dart';
import 'package:agritech/utils/contants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controller/login_controller.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  static const routeName = '/login-screen';

  final _key = GlobalKey<FormState>();
  final LoginController controller = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
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
                alignment: Alignment.centerRight,
                child: Text(
                  "لاگ ان کریں",
                  style: textStyle.copyWith(
                    fontSize: height * 0.035,
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              TextFormField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null) {
                    return "ای میل ایک مطلوبہ فیلڈ ہے";
                  }
                  return RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)
                      ? null
                      : "ایک درست ای میل درج کریں";
                },
                decoration: fieldStyle.copyWith(
                  hintText: 'ای میل',
                  hintStyle: textStyle.copyWith(
                      fontWeight: FontWeight.w400,
                      color: grayColor,
                      fontSize: height * 0.017),
                  prefixIcon: const Icon(Icons.email),
                ),
              ),
              SizedBox(
                height: height * 0.015,
              ),
              Obx(
                () => TextFormField(
                  controller: controller.passwordController,
                  obscureText: controller.passVisibility.value,
                  validator: (value) {
                    if (value == null) {
                      return 'پاس ورڈ کی ضرورت ہے';
                    } else if (value.length < 6) {
                      return 'برائے مہربانی صحیح پاسورڈ درج کریں';
                    }
                    return null;
                  },
                  decoration: fieldStyle.copyWith(
                    hintText: 'پاس ورڈ',

                    // prefixIcon: SvgPicture.asset(
                    //   'assets/icons/lock.svg',
                    //   theme: const SvgTheme(
                    //       currentColor: Colors.black12, fontSize: 5, xHeight: 5),
                    // ),
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
                    controller.loginUser(controller.emailController.text.trim(),
                        controller.passwordController.text.trim());
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
                  "لاگ ان کریں",
                  style: textStyle.copyWith(
                      fontSize: height * 0.02, color: Colors.white),
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Row(
                children: [
                  const Expanded(
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                    child: Text(
                      "یا اس کے ساتھ سائن اپ کریں",
                      style: textStyle.copyWith(
                          fontWeight: FontWeight.w400, color: grayColor),
                    ),
                  ),
                  const Expanded(
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.white,
                          fixedSize: Size(width * 0.88, height * 0.06),
                          side:
                              const BorderSide(color: lightGrayColor, width: 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        onPressed: () {
                          controller.registerUserGoogle();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/icons/google.svg'),
                            SizedBox(
                              width: width * 0.04,
                            ),
                            Text(
                              "Google",
                              style: textStyle.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: height * 0.018,
                              ),
                            ),
                          ],
                        )),
                  ),
                  // SizedBox(
                  //   width: width * 0.05,
                  // ),
                  // Expanded(
                  //   child: ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //         elevation: 0,
                  //         backgroundColor: Colors.white,
                  //         fixedSize: Size(width * 0.88, height * 0.06),
                  //         side:
                  //             const BorderSide(color: lightGrayColor, width: 1),
                  //         shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(5)),
                  //       ),
                  //       onPressed: () {
                  //         controller.registerUserGoogle();
                  //       },
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           SvgPicture.asset('assets/icons/facebook.svg'),
                  //           SizedBox(
                  //             width: width * 0.04,
                  //           ),
                  //           Text(
                  //             "Facebook",
                  //             style: textStyle.copyWith(
                  //               fontWeight: FontWeight.w600,
                  //               color: Colors.black,
                  //               fontSize: height * 0.018,
                  //             ),
                  //           ),
                  //         ],
                  //       )),
                  // ),
                ],
              ),
              SizedBox(
                height: width * 0.08,
              ),
              RichText(
                text: TextSpan(
                    text: "کیا کوئی اکاؤنٹ نہیں ہے؟",
                    style: textStyle.copyWith(
                        color: grayColor, fontWeight: FontWeight.w400),
                    children: [
                      TextSpan(
                          text: "سائن اپ",
                          style: textStyle.copyWith(
                            color: primaryColor,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.popAndPushNamed(
                                  context, SignUpScreen.routeName);
                            }),
                    ]),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
