import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view_model/auth_viewmodel.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();
  final emailController = TextEditingController(text: "awais@gmail.com");
  final passwordController = TextEditingController(text: "awais12");
  Rx<bool> passVisibility = false.obs;
  void loginUser(String email, String password) {
    AuthRepository.instance.loginWithEmailAndPassword(email, password);
  }

  void registerUserGoogle() {
    AuthRepository.instance.signInWithGoogle();
  }
}
