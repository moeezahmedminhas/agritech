import 'package:agritech/features/auth/view_model/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();
  final emailController = TextEditingController(text: "awais@gmail.com");
  final passwordController = TextEditingController(text: "awais12");
  final confirmPassController = TextEditingController(text: "awais12");
  Rx<bool> passVisibility = false.obs;
  Rx<bool> confirmPassVisibility = false.obs;
  void registerUser(String email, String password) {
    AuthRepository.instance.createUserWithEmailAndPassword(email, password);
  }

  void registerUserGoogle() {
    AuthRepository.instance.signInWithGoogle();
  }

  // void registerUserFacebook(String email, String password) {
  //   AuthRepository.instance.signInWithFacebook();
  // }
}
