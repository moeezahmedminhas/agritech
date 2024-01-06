import 'package:agritech/features/company/screens/edit_product_screen.dart';
import 'package:agritech/features/auth/view/change_password_screen.dart';
import 'package:agritech/features/auth/view/payment_methods_screen.dart';
import 'package:agritech/features/auth/view/privacy_policy_screen.dart';
import 'package:agritech/features/auth/view/settings_screen.dart';
import 'package:agritech/features/auth/view/shipping_address_screen.dart';
import 'package:agritech/features/auth/view/user_data_screen.dart';
import 'package:agritech/features/auth/view_model/auth_viewmodel.dart';
import 'package:agritech/features/company/screens/add_product_screen.dart';
import 'package:agritech/features/order/screens/order_detail_screen.dart';
import 'package:agritech/features/order/screens/order_history.dart';
import 'package:agritech/features/products/screens/product_details.dart';
import 'package:agritech/features/products/screens/product_reviews.dart';
import 'package:agritech/languages.dart';
import 'package:agritech/features/order/screens/order_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'features/admin/views/admin_home_screen.dart';
import 'features/auth/view/login_screen.dart';
import 'features/auth/view/signup_screen.dart';
import 'features/products/screens/add_review_screen.dart';
import 'firebase_options.dart';
// import 'package:device_preview/device_preview.dart';
// import 'package:flutter/foundation.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
//       .then((value) => Get.put(
//             AuthRepository(),
//           ));

//   await SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//   ]);
//   runApp(DevicePreview(
//     enabled: !kReleaseMode,
//     builder: (context) => const MyApp(), // Wrap your app
//   ));
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(
            AuthRepository(),
          ));

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(
    const MyApp(), // Wrap your app
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        onUnknownRoute: (settings) {
          return MaterialPageRoute(builder: (context) => const Scaffold());
        },
        title: 'ایگریٹیک',
        translations: Languages(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff00B251)),
          // useMaterial3: true,
        ),
        // home: SignUpScreen(),
        routes: {
          SignUpScreen.routeName: (context) => SignUpScreen(),
          LoginScreen.routeName: (context) => LoginScreen(),
          AddProductScreen.routeName: (context) => AddProductScreen(),
          UserDataScreen.routeName: (context) => UserDataScreen(),
          ProductDetails.routeName: (context) => ProductDetails(),
          OrderScreen.routeName: (context) => OrderScreen(),
          OrderHistoryScreen.routeName: (context) => const OrderHistoryScreen(),
          OrderDetailScreen.routeName: (context) => const OrderDetailScreen(),
          ShippingAddressScreen.routeName: (context) => ShippingAddressScreen(),
          SettingsScreen.routeName: (context) => SettingsScreen(),
          PaymentMethods.routeName: (context) => const PaymentMethods(),
          AdminHomeScreen.routeName: (context) => const AdminHomeScreen(),
          EditProductScreen.routeName: (context) => EditProductScreen(),
          AddProductReviewScreen.routeName: (context) =>
              AddProductReviewScreen(),
          ProductReviewScreen.routeName: (context) => ProductReviewScreen(),
          PrivacyPolicyScreen.routeName: (context) =>
              const PrivacyPolicyScreen(),
          ChangePasswordScreen.routeName: (context) => ChangePasswordScreen(),
        }
        //har widget me text k sath mesage.tr use krna ha
        );
  }
}
