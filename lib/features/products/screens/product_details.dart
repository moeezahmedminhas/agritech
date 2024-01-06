import 'package:agritech/features/company/screens/edit_product_screen.dart';
import 'package:agritech/features/products/screens/add_review_screen.dart';
import 'package:agritech/features/products/screens/product_reviews.dart';
import 'package:agritech/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import '../../../models/product.dart';
import '../../../models/review.dart';
import '../../../utils/contants.dart';
import '../../auth/controller/user_data_controller.dart';
import '../controller/product_controller.dart';
import '../widgets/product_item.dart';

class ProductDetails extends StatelessWidget {
  static const routeName = '/product-details';
  ProductDetails({super.key});
  final ProductController _productController = Get.put(ProductController());
  final UserDataController _userDataController = Get.put(UserDataController());

  @override
  Widget build(BuildContext context) {
    final Product product = Get.arguments as Product;
    List<Product> productList;
    String productMetric = "";
    if (product.category == productType[0] ||
        product.category == productType[2]) {
      productMetric = 'kg /';
    } else {
      productMetric = 'item / ';
    }
    // final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "تفصیلات",
          style: textStyle,
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () async {
              _userDataController.appUser.value!.type == userTypes[1]
                  ? Get.toNamed(EditProductScreen.routeName, arguments: product)
                  : Get.toNamed(AddProductReviewScreen.routeName,
                      arguments: product);
            },
            icon: const Icon(Icons.edit),
          )
        ],
      ),
      body: ListView(children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
          child: SizedBox(
            height: Get.height * 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Get.height * 0.009),
                  child: Image.network(
                    product.images[0],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: Get.height * 0.25,
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
                SizedBox(
                  height: Get.height * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RatingBar.builder(
                      ignoreGestures: true,
                      initialRating: product.averageRating,
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
                    RichText(
                      text: TextSpan(
                          text: "(${product.reviewCount.toString()})   ",
                          style: textStyle.copyWith(
                              fontSize: Get.height * 0.024,
                              color: Colors.amber[700]),
                          children: [
                            TextSpan(
                              text: product.name,
                              style: textStyle.copyWith(
                                fontSize: Get.height * 0.026,
                              ),
                            )
                          ]),
                    ),
                  ],
                ),
                SizedBox(
                  height: Get.height * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$productMetric ${product.price} Rs. ",
                      style: textStyle.copyWith(
                        color: grayColor,
                      ),
                    ),
                    Text(
                      product.stockCount > 0
                          ? "اسٹاک میں دستیاب ہے"
                          : "زخیرے سے باہر",
                      style: textStyle.copyWith(
                          fontWeight: FontWeight.w600, color: primaryColor),
                    ),
                  ],
                ),
                SizedBox(
                  height: Get.height * 0.005,
                ),
                Text(
                  "اسٹاک میں شامل ہیں: ${product.stockCount}",
                  style: textStyle.copyWith(
                      fontWeight: FontWeight.w600,
                      color: grayColor,
                      fontSize: Get.height * 0.016),
                ),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                Text(
                  "تفصیل",
                  style: textStyle.copyWith(fontSize: Get.height * 0.02),
                ),
                SizedBox(
                  height: Get.height * 0.018,
                ),
                Text(
                  product.description,
                  style: textStyle.copyWith(
                      color: grayColor, fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                Text(
                  "دیگر مصنوعات",
                  style: textStyle.copyWith(fontSize: Get.height * 0.02),
                ),
                SizedBox(
                  height: Get.height * 0.018,
                ),
                SizedBox(
                  height: height * 0.17,
                  child: Obx(
                    () {
                      if (_productController.isLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (_productController.products.isEmpty) {
                        return const Center(
                          child: Text('کوئی مصنوعات نہیں ملے'),
                        );
                      } else {
                        productList =
                            _productController.products.map((e) => e).toList();
                        productList
                            .removeWhere((element) => element.id == product.id);
                        if (productList.isEmpty) {
                          return const Center(
                            child: Text('دکھانے کے لیے مزید مصنوعات نہیں'),
                          );
                        } else {
                          return GridView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: productList.length,
                            itemBuilder: (context, index) {
                              final product = productList[index];
                              return InkWell(
                                  onTap: () {
                                    // print("object");
                                    // Get.toNamed(ProductDetails.routeName,
                                    //     arguments: product);
                                    Navigator.of(context).pushNamed(
                                        ProductDetails.routeName,
                                        arguments: product);
                                  },
                                  child: ProductWidget(product: product));
                            },
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              mainAxisSpacing: 10,
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(ProductReviewScreen.routeName,
                            arguments: product);
                      },
                      child: Text(
                        "سارے دکھاو",
                        style: textStyle.copyWith(
                          fontSize: Get.height * 0.02,
                          color: primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    Text(
                      "جائزے",
                      style: textStyle.copyWith(fontSize: Get.height * 0.02),
                    ),
                  ],
                ),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                Expanded(
                  child: StreamBuilder<List<Review>>(
                    stream:
                        _productController.loadReviewsForProduct(product.id),
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
                          shrinkWrap: true,
                          itemCount: reviews.length,
                          // physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            Review review = reviews[index];
                            // Build your UI for each review item here
                            // You can access review properties like review.title, review.rating, etc.
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      review.userID,
                                      style: textStyle,
                                    ),
                                    Text(
                                      "(${review.rating})",
                                      style: textStyle.copyWith(
                                          color: Colors.amber[700]),
                                    )
                                  ],
                                ),
                                Text(
                                  review.comment,
                                  style: textStyle.copyWith(
                                      color: grayColor,
                                      fontWeight: FontWeight.w400),
                                  // overflow: TextOverflow.clip,
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
      floatingActionButton:
          _userDataController.appUser.value!.type == userTypes[0]
              ? SizedBox(
                  width: Get.width * 1 - Get.width * 0.08,
                  height: Get.height * 0.06,
                  child: ElevatedButton(
                    onPressed: () {
                      _productController.addProductToCart(product);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    child: Text(
                      "ٹوکری میں شامل کریں",
                      style: textStyle.copyWith(
                          fontSize: Get.height * 0.02, color: Colors.white),
                    ),
                  ),
                )
              : const SizedBox(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
