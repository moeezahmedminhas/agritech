import 'package:agritech/features/auth/controller/user_data_controller.dart';
import 'package:agritech/features/auth/view/profile_screen.dart';
import 'package:agritech/features/company/screens/company_dashboard.dart';
import 'package:agritech/features/search/screens/search_screen.dart';
import 'package:agritech/models/user.dart';
import 'package:agritech/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'add_product_screen.dart';

class CompanyHomeScreen extends StatefulWidget {
  const CompanyHomeScreen({super.key});
  static const routeName = '/admin-home-screen';
  @override
  State<CompanyHomeScreen> createState() => _CompanyHomeScreenState();
}

class _CompanyHomeScreenState extends State<CompanyHomeScreen> {
  int _selectedIndex = 0;
  AppUser? user;
  UserDataController controller = Get.put(UserDataController());

  static final List<Widget> _widgetOptions = <Widget>[
    CompanyDashboard(),
    SearchScreen(),
    AddProductScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    controller.getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: primaryColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              color: primaryColor,
            ),
            label: 'احکامات',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: primaryColor,
            ),
            label: 'تلاش کریں',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: primaryColor,
            ),
            label: '+ پروڈکٹ',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline_outlined,
              color: primaryColor,
            ),
            label: 'پروفائل',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        elevation: 5,
        backgroundColor: Colors.white,
      ),
    );
  }
}
