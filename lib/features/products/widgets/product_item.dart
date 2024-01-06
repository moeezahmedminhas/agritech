import 'package:agritech/features/auth/controller/user_data_controller.dart';
import 'package:agritech/models/product.dart';
import 'package:agritech/utils/colors.dart';
import 'package:agritech/utils/contants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/product_controller.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  ProductWidget({Key? key, required this.product}) : super(key: key);
  final ProductController productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    String productMetric = "";
    if (product.category == productType[0] ||
        product.category == productType[2]) {
      productMetric = 'kg/';
    } else {
      productMetric = 'item/ ';
    }
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: lightGrayColor, width: 0.7)),
      child: Column(children: [
        Expanded(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
            child: Image.network(
              product.images[0],
              fit: BoxFit.cover,
              width: double.infinity,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(Get.width * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: textStyle.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$productMetric${product.price}: قیمت",
                    style: textStyle.copyWith(
                        fontWeight: FontWeight.w500,
                        color: grayColor,
                        fontSize: Get.height * 0.012),
                  ),
                  UserDataController.instance.appUser.value!.type ==
                          userTypes[1]
                      ? product.stockCount <= 3
                          ? Container(
                              width: Get.width * 0.05,
                              height: Get.width * 0.05,
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(5)),
                            )
                          : Container(
                              width: Get.width * 0.05,
                              height: Get.width * 0.05,
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(5)),
                            )
                      : GestureDetector(
                          onTap: () {
                            productController.addProductToCart(product);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(5)),
                            child: Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Get.width * 0.01),
                                child: Text(
                                  "+",
                                  style: textStyle.copyWith(
                                      color: Colors.white,
                                      fontSize: Get.width * 0.04),
                                ),
                              ),
                            ),
                          ),
                        )
                ],
              ),
            ],
          ),
        )
      ]),
    );
  }
}
