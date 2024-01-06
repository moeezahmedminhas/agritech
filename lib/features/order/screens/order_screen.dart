import 'package:agritech/features/cart/controller/cart_controller.dart';
import 'package:agritech/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth/controller/user_data_controller.dart';
import '../../../models/user.dart';
import '../../../utils/contants.dart';
import '../controller/order_controller.dart';
import '../widget/order_info.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/order-screen';
  final UserDataController _user = Get.find();
  final CartController _cartController = Get.put(CartController.instance);
  final OrderController _orderController = Get.put(OrderController.instance);

  OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    AppUser? appUser = _user.appUser.value;
    double totalAmount = 0.0;
    totalAmount = _cartController.cartItems
        .fold(_orderController.deliveryCharges.value.toDouble(), (sum, item) {
      return sum + item.totalPrice;
    });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "آرڈر کی تفصیلات",
          style: textStyle.copyWith(),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(Get.width * 0.05),
        child: appUser != null
            ? Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(
                  'ترسیل کا پتہ',
                  style: textStyle.copyWith(fontSize: Get.height * 0.026),
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: lightGrayColor, width: 0.7),
                  ),
                  padding: EdgeInsets.all(Get.width * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        appUser.address,
                        style: textStyle.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: Get.height * 0.022,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      Text(
                        '${appUser.phone} : فون',
                        style: textStyle.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: Get.height * 0.022,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.04,
                ),
                Text(
                  "${_cartController.cartItems.length}  : کل اشیاء",
                  style: textStyle.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: Get.height * 0.022),
                ),
                SizedBox(
                  height: Get.height * 0.025,
                ),
                Text(
                  'آرڈر کی معلومات',
                  style: textStyle.copyWith(fontSize: Get.height * 0.024),
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: lightGrayColor, width: 0.7),
                  ),
                  padding: EdgeInsets.all(Get.width * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      OrderInfoWidget(
                        text: 'ذیلی کل',
                        value: _cartController.cartItems.fold(0.0, (sum, item) {
                          return sum + item.totalPrice;
                        }).toString(),
                      ),
                      SizedBox(
                        height: Get.height * 0.01,
                      ),
                      OrderInfoWidget(
                        text: 'ڈیلیوری چارجز',
                        value: _orderController.deliveryCharges.toString(),
                      ),
                      SizedBox(
                        height: Get.height * 0.01,
                      ),
                      OrderInfoWidget(
                        text: 'رعایت',
                        value: 0.toString(),
                      ),
                      SizedBox(
                        height: Get.height * 0.01,
                      ),
                      Divider(
                        thickness: Get.width * 0.004,
                      ),
                      SizedBox(
                        height: Get.height * 0.01,
                      ),
                      OrderInfoWidget(
                        text: 'کل رقم',
                        value: totalAmount.toString(),
                        fontSize: 0.019,
                      ),
                    ],
                  ),
                ),
              ])
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
          width: Get.width * 1 - Get.width * 0.08,
          height: Get.height * 0.06,
          child: ElevatedButton(
            style: buttonStyle.copyWith(
              textStyle: MaterialStateProperty.resolveWith(
                (states) {
                  return const TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.w600, // Set your desired font size here
                  );
                },
              ),
            ),
            onPressed: () async {
              await _cartController.subtractItems(
                  context, screenSize, totalAmount);
            },
            child: const Text("حکم کی تصدیق"),
          )),
    );
  }
}
