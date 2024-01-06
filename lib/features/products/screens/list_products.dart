// import 'package:agritech/features/admin/manage_products/view/add_product_screen.dart';
import 'package:agritech/features/products/widgets/product_item.dart';
import 'package:agritech/utils/app_drawer.dart';
import 'package:agritech/utils/colors.dart';
import 'package:agritech/utils/contants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/controller/user_data_controller.dart';
import '../controller/product_controller.dart';
import 'product_details.dart';

class ProductScreen extends StatelessWidget {
  final ProductController productController = Get.put(ProductController());
  final UserDataController userDataController = Get.put(UserDataController());
  final TextEditingController searchTextController = TextEditingController();

  ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    userDataController.getUserData();
    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: AppDrawer(),
      appBar: AppBar(
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Align(
          alignment: Alignment.centerRight,
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                userDataController.appUser.value?.fullName != null
                    ? Text(
                        "!${userDataController.appUser.value?.fullName} السلام علیکم",
                        style: textStyle.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: Get.height * 0.015,
                        ),
                      )
                    : Container(),
                Text(
                  "اپنی خدمات سے لطف اندوز ہوں۔",
                  style: textStyle.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: Get.height * 0.02),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: Get.height * 0.01),
              SizedBox(
                height: Get.height * 0.052,
                child: TextField(
                  controller: searchTextController,
                  decoration: fieldStyle.copyWith(
                    hintText: "یہاں تلاش کریں",
                    hintTextDirection: TextDirection.rtl,
                    hintStyle: TextStyle(fontSize: height * 0.015),
                    prefixIcon: const Icon(Icons.search, color: lightGrayColor),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: Get.height * 0.022,
                        horizontal: Get.width * 0.03),
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  onChanged: (value) {
                    productController.searchProducts(value);
                  },
                ),
              ),
              SizedBox(height: Get.height * 0.03),
              Stack(children: [
                SizedBox(
                  child: Image.asset("assets/images/discount.png"),
                ),
                Positioned(
                  bottom: height * 0.01,
                  // left: width * 0.025,
                  child: SizedBox(
                    width: width * 1 - width * 0.085,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Get.width * 0.03,
                          vertical: Get.width * 0.02),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "10% ڈسکاؤنٹ",
                              style: textStyle.copyWith(
                                color: Colors.white,
                                fontSize: Get.height * 0.018,
                              ),
                            ),
                            Text(
                              "اپنے بیج بہترین قیمت پر حاصل کریں",
                              style: textStyle.copyWith(
                                  color: Colors.white,
                                  fontSize: Get.height * 0.022),
                            ),
                            // SizedBox(
                            //   width: width * 0.4,
                            //   child:
                            // ),
                          ]),
                    ),
                  ),
                ),
              ]),
              SizedBox(
                height: Get.height * 0.025,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "نمایاں مصنوعات",
                  style: textStyle.copyWith(
                    fontSize: Get.height * 0.02,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: Get.height * 0.017,
              ),
              Obx(
                () {
                  if (productController.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    var productList = productController.isSearching.isTrue
                        ? productController.filteredProducts
                        : productController.products;
                    if (productList.isEmpty) {
                      return const Center(
                        child: Text('No products found.'),
                      );
                    } else {
                      return GridView.builder(
                        itemCount: productList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final product = productList[index];
                          return InkWell(
                              onTap: () {
                                Get.toNamed(ProductDetails.routeName,
                                    arguments: product);
                              },
                              child: ProductWidget(product: product));
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: height * 0.015,
                          crossAxisSpacing: width * 0.035,
                          crossAxisCount: 2,
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
