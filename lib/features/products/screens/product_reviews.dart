import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../../../models/product.dart';
import '../../../models/review.dart';
import '../../../utils/colors.dart';
import '../../../utils/contants.dart';
import '../controller/product_controller.dart';

class ProductReviewScreen extends StatelessWidget {
  ProductReviewScreen({super.key});
  static const routeName = "/reviews-screen";
  final ProductController _productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    final Product product = Get.arguments as Product;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          "کے جائزے ${product.name}",
          style: textStyle,
        ),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<List<Review>>(
        stream: _productController.loadReviewsForProduct(product.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('خرابی: ${snapshot.error.toString()}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Check if there's no data or the data is empty
            return const Text('کوئی جائزے دستیاب نہیں ہیں');
          } else {
            // Render the list of reviews using the snapshot data
            List<Review> reviews = snapshot.data!;
            return ListView.builder(
              itemCount: reviews.length,
              // physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                Review review = reviews[index];
                // Build your UI for each review item here
                // You can access review properties like review.title, review.rating, etc.
                return Padding(
                  padding: EdgeInsets.all(Get.width * 0.03),
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(Get.width * 0.03),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                review.userID,
                                style: textStyle,
                              ),
                              RatingBar.builder(
                                ignoreGestures: true,
                                initialRating: review.rating,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 20,
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: Colors.amber[700],
                                ),
                                onRatingUpdate: (rating) {
                                  // Handle rating changes
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Get.height * 0.01,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              review.comment,
                              style: textStyle.copyWith(
                                  color: grayColor,
                                  fontWeight: FontWeight.w400),
                              // overflow: TextOverflow.clip,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
