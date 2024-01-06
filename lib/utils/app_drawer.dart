import 'package:agritech/models/user.dart';
import 'package:agritech/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../features/auth/controller/user_data_controller.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({super.key});
  final UserDataController userDataController = Get.put(UserDataController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<AppUser>(
          future: userDataController.getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              padding: const EdgeInsets.all(0),
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: primaryColor,
                  ), //BoxDecoration
                  child: UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(color: primaryColor),
                    accountName: Text(
                      snapshot.data!.fullName,
                      style: TextStyle(fontSize: Get.height * 0.018),
                    ),
                    accountEmail: Text(snapshot.data!.email),
                    currentAccountPictureSize: Size.square(Get.height * 0.06),
                    currentAccountPicture: ClipOval(
                      child: Image.network(
                        snapshot.data!.profilePic,
                      ), //Text
                    ), //circleAvatar
                  ), //UserAccountDrawerHeader
                ), //DrawerHeader
                // ListTile(
                //   leading: const Icon(Icons.person),
                //   title: const Text(' My Profile '),
                //   onTap: () {
                //     Navigator.pop(context);
                //   },
                // ),
                // ListTile(
                //   leading: const Icon(Icons.book),
                //   title: const Text(' My Course '),
                //   onTap: () {
                //     Navigator.pop(context);
                //   },
                // ),
                // ListTile(
                //   leading: const Icon(Icons.workspace_premium),
                //   title: const Text(' Go Premium '),
                //   onTap: () {
                //     Navigator.pop(context);
                //   },
                // ),
                // ListTile(
                //   leading: const Icon(Icons.video_label),
                //   title: const Text(' Saved Videos '),
                //   onTap: () {
                //     Navigator.pop(context);
                //   },
                // ),
                // ListTile(
                //   leading: const Icon(Icons.edit),
                //   title: const Text(' Edit Profile '),
                //   onTap: () {
                //     Navigator.pop(context);
                //   },
                // ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('لاگ آوٹ'),
                  onTap: () {
                    UserDataController.instance.logoutFromApp();
                  },
                ),
              ],
            );
          }),
    );
  }
}
