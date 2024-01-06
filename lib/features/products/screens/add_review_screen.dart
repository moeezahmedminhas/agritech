import 'package:agritech/models/product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../utils/contants.dart';
import 'package:agritech/features/products/controller/product_controller.dart';

class AddProductReviewScreen extends StatelessWidget {
  AddProductReviewScreen({super.key});
  static const routeName = "/add-review-screen";
  final _productController = Get.put(ProductController());
  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double rating = 0;
    final productID = (Get.arguments as Product).id;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "پروڈکٹ کا جائزہ",
          style: textStyle,
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Padding(
            padding: EdgeInsets.all(Get.width * 0.03),
            child: Column(
              children: [
                SizedBox(
                  height: Get.height * 0.1,
                ),
                Text(
                  'مصنوعات کی وضاحت',
                  style: textStyle.copyWith(
                    fontSize: Get.height * 0.02,
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.015,
                ),
                TextFormField(
                  maxLines: 5,
                  decoration:
                      fieldStyle.copyWith(hintText: 'جائزہ تبصرہ درج کریں'),
                  controller: _productController.reviewCommentController,
                  validator: (value) {
                    if (value == null) {
                      return 'جائزہ تبصرہ درکار ہے۔';
                    } else if (value.length < 10) {
                      return 'ایک درست جائزہ درج کریں۔';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                Text(
                  'درجہ بندی',
                  style: textStyle.copyWith(
                    fontSize: Get.height * 0.02,
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.01,
                ),
                RatingBar.builder(
                  initialRating: 1,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 40,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rate) {
                    rating = rate;
                  },
                ),
                SizedBox(
                  height: Get.height * 0.1,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_key.currentState!.validate() && rating != 0) {
                      _productController.addReviewToProduct(
                          productID: productID,
                          comment:
                              _productController.reviewCommentController.text,
                          rating: rating);
                    }
                  },
                  style: buttonStyle,
                  child: const Text("جائزہ شامل کریں"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
