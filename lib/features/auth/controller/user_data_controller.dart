import 'package:agritech/features/auth/view/login_screen.dart';
import 'package:agritech/features/auth/view_model/auth_viewmodel.dart';
import 'package:agritech/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserDataController extends GetxController {
  static UserDataController get instance => Get.find();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final zipController = TextEditingController();
  final phoneController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final userTypeController = TextEditingController();
  Rx<bool> passVisibility = false.obs;
  Rx<bool> currentPassVisibility = false.obs;

  final AuthRepository _authRepository = AuthRepository.instance;
  var appUser = Rxn<AppUser>();

  void saveUserDataToFirebase(String name, String address, String postalCode,
      String phoneNumber, String userType) {
    _authRepository.saveUserDataToFirebase(
        name, address, postalCode, phoneNumber, userType);
  }

  void updateAddress(String address, String postalCode) {
    _authRepository.updateAddress(address, postalCode);
  }

  Future<AppUser> getUserData() async {
    appUser.value = await _authRepository.getUserData();
    nameController.text = appUser.value!.fullName;
    addressController.text = appUser.value!.address;
    phoneController.text = appUser.value!.phone;
    zipController.text = appUser.value!.postalCode;
    appUser.refresh();
    return appUser.value!;
  }

  Stream<AppUser?> getUserDataStream() {
    return _authRepository.getUserDataStream();
  }

  void logoutFromApp() {
    _authRepository.logout();
    Get.offNamedUntil(LoginScreen.routeName, (route) => false);
  }

  void updateProfilePic() {
    _authRepository.selectProfileImage();
  }

  Future<void> changePassword(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    final currentPassword = currentPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('پاس ورڈ میچ نہیں کرتے'),
        ),
      );
      return;
    }
    try {
      await user.reauthenticateWithCredential(
        EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        ),
      );

      await user.updatePassword(newPassword);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('پاس ورڈ کامیابی سے تبدیل ہو گیا'),
        ),
      );
      currentPasswordController.text = "";
      newPasswordController.text = "";
      confirmPasswordController.text = "";
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('موجودہ پاس ورڈ غلط ہے'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message.toString()),
          ),
        );
      }
    }
  }
}
