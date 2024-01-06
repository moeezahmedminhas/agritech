import 'package:agritech/features/cart/controller/cart_controller.dart';
import 'package:agritech/models/cart_item.dart';
import 'package:agritech/utils/colors.dart';
import 'package:agritech/utils/contants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});
  final CartController controller = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    controller.fetchCartItems();

    List<CartItem> cartItems;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        // leading: IconButton(
        //     onPressed: () {},
        //     icon: const Icon(
        //       Icons.menu,
        //       color: Colors.black,
        //     )),
        title: Text(
          "میری ٹوکری",
          style: textStyle.copyWith(),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(Get.width * 0.05),
        child: Obx(
          () {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (controller.cartItems.isEmpty) {
              return const Center(
                child: Text('کوئی پروڈکٹس نہیں ملے'),
              );
            } else {
              cartItems = controller.cartItems;
              if (cartItems.isEmpty) {
                return const Center(
                  child: Text('کوئی پروڈکٹس دستیاب نہیں ہیں'),
                );
              } else {
                return ListView.separated(
                  separatorBuilder: (context, index) =>
                      SizedBox(height: Get.height * 0.016), // Add spacing here

                  itemCount: cartItems.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final cartItem = cartItems[index];
                    return Slidable(
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (_) {
                              controller.addRemoveCartItem(
                                  index, 'del'); // Use '+' for adding
                            },
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'حذف کریں',
                            spacing: 3,
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                          ),
                        ],
                      ),
                      child: CartItemWidget(
                        cartItem: cartItem,
                        index: index,
                      ),
                    );
                  },
                );
              }
            }
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(
        () => controller.cartItems.isNotEmpty
            ? SizedBox(
                width: Get.width * 1 - Get.width * 0.08,
                height: Get.height * 0.06,
                child: ElevatedButton(
                  style: buttonStyle.copyWith(
                    textStyle: MaterialStateProperty.resolveWith(
                      (states) {
                        return const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight
                              .w600, // Set your desired font size here
                        );
                      },
                    ),
                  ),
                  onPressed: () {
                    controller.verifyItems();
                  },
                  child: const Text("اس کو دیکھو"),
                ),
              )
            : const SizedBox(),
      ),
    );
  }
}
