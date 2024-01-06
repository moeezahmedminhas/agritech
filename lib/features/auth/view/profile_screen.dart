import 'package:agritech/features/auth/view/payment_methods_screen.dart';
import 'package:agritech/features/auth/view/privacy_policy_screen.dart';
import 'package:agritech/features/auth/view/settings_screen.dart';
import 'package:agritech/features/auth/view/shipping_address_screen.dart';
import 'package:agritech/features/order/screens/order_history.dart';
import 'package:agritech/utils/app_drawer.dart';
import 'package:agritech/utils/colors.dart';
import 'package:agritech/utils/contants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/user_data_controller.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final UserDataController _userDataController = Get.put(UserDataController());

  @override
  Widget build(BuildContext context) {
    _userDataController.getUserData();

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: AppDrawer(),
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
            splashRadius: Get.width * 0.06,
            icon: const Icon(Icons.edit),
            onPressed: () {
              _userDataController.updateProfilePic();
            },
          ),
        ],
        title: Text(
          "پروفائل",
          style: textStyle.copyWith(),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  StreamBuilder(
                      stream: _userDataController.getUserDataStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error.toString()}');
                        }
                        return CircleAvatar(
                          backgroundColor: grayColor,
                          radius: 70,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(150),
                            child: Image.network(snapshot.data!.profilePic),
                          ),
                        );
                      }),
                  Positioned(
                      bottom: -92,
                      child: SizedBox(
                          width: Get.width * 1 - Get.width * 0.08,
                          height: Get.height * 0.2,
                          child: Image.asset('assets/images/profile.png'))),
                ],
              ),
            ),
            SizedBox(
              height: Get.height * 0.08,
            ),
            Text(
              _userDataController.appUser.value!.fullName,
              style: textStyle.copyWith(
                  fontSize: Get.height * 0.024, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
            _userDataController.appUser.value!.type == userTypes[0]
                ? ProfileListTile(
                    onTap: () {
                      Get.toNamed(ShippingAddressScreen.routeName);
                    },
                    name: "شپنگ ایڈریس",
                    suffix: Icons.arrow_forward_ios,
                    prefix: Icons.location_on)
                : const SizedBox(),
            _userDataController.appUser.value!.type == userTypes[0]
                ? ProfileListTile(
                    onTap: () {
                      Get.toNamed(PaymentMethods.routeName);
                    },
                    name: "ادائیگی کی ترتیبات",
                    suffix: Icons.arrow_forward_ios,
                    prefix: Icons.paypal)
                : const SizedBox(),
            ProfileListTile(
                onTap: () {
                  Get.toNamed(OrderHistoryScreen.routeName);
                },
                name: "آرڈر کی تاریخ",
                suffix: Icons.arrow_forward_ios,
                prefix: Icons.history),
            ProfileListTile(
                onTap: () {
                  Get.toNamed(SettingsScreen.routeName);
                },
                name: "ترتیبات",
                suffix: Icons.arrow_forward_ios,
                prefix: Icons.settings),
            ProfileListTile(
                onTap: () {
                  Get.toNamed(PrivacyPolicyScreen.routeName);
                },
                name: "رازداری کی پالیسی",
                suffix: Icons.arrow_forward_ios,
                prefix: Icons.lock_outline),
          ]),
        ),
      ),
    );
  }
}

class ProfileListTile extends StatelessWidget {
  final VoidCallback onTap;
  final String name;
  final IconData suffix;
  final IconData prefix;

  const ProfileListTile({
    super.key,
    required this.onTap,
    required this.name,
    required this.suffix,
    required this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: Get.height * 0.045,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(prefix, size: Get.height * 0.025),
            SizedBox(
                width: Get.width * 0.05), // You can adjust the spacing here
            Expanded(
              child: Text(
                name,
                style: textStyle.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: Get.height * 0.016,
                ),
              ),
            ),
            Icon(suffix, size: Get.height * 0.018),
          ],
        ),
      ),
    );
  }
}
