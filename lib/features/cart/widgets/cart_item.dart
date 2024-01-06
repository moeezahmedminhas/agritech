import 'package:agritech/features/products/controller/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/cart_item.dart';
import '../../../utils/colors.dart';
import '../../../utils/contants.dart';
import '../controller/cart_controller.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final int index;
  const CartItemWidget({
    super.key,
    required this.cartItem,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final productController = ProductController.instance;
    final CartController controller = Get.put(CartController());
    final productIndex = productController.products.indexWhere(
      (element) => element.id == cartItem.productID,
    );
    final stockCount = productController.products[productIndex].stockCount;
    return Container(
      // padding: EdgeInsets.symmetric(
      //     vertical: Get.height * 0.02, horizontal: Get.width * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26, // Shadow color
            blurRadius: 0.5, // Spread of the shadow
            offset: Offset(0, 2), // Offset of the shadow
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: Get.height * 0.02, horizontal: Get.width * 0.03),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                cartItem.productImage,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: Get.width * 0.04,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.productName,
                  style: textStyle.copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: Get.height * 0.005,
                ),
                Text('Rs: ${cartItem.unitPrice} ',
                    style: textStyle.copyWith(
                        fontWeight: FontWeight.w500, color: grayColor)),
                SizedBox(
                  height: Get.height * 0.005,
                ),
                Text('Stock: ${stockCount.toString()} ',
                    style: textStyle.copyWith(
                        fontSize: Get.height * 0.013,
                        fontWeight: FontWeight.w200,
                        color: grayColor)),
                // productController.products[index].stockCount.toString()
              ],
            ),
            const Expanded(child: SizedBox()),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    controller.addRemoveCartItem(index, '+');
                  },
                  child: Icon(
                    Icons.add_circle,
                    color: grayColor,
                    size: Get.width * 0.065,
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.005,
                ),
                Text(cartItem.quantity.toString(),
                    style: textStyle.copyWith(
                        fontWeight: FontWeight.w500,
                        color: stockCount < cartItem.quantity
                            ? Colors.red
                            : grayColor)),
                SizedBox(
                  height: Get.height * 0.005,
                ),
                InkWell(
                  onTap: () {
                    controller.addRemoveCartItem(index, '-');
                  },
                  child: Icon(
                    Icons.remove_circle,
                    color: grayColor,
                    size: Get.width * 0.065,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
