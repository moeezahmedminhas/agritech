import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/colors.dart';
import '../../../utils/contants.dart';
import '../../auth/controller/user_data_controller.dart';
import '../../products/controller/product_controller.dart';
import '../../products/screens/product_details.dart';
import '../../products/widgets/product_item.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});
  final ProductController productController = Get.put(ProductController());
  final UserDataController userDataController = Get.put(UserDataController());
  final TextEditingController searchTextController = TextEditingController();

  @override
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    userDataController.getUserData();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: SizedBox(
          height: Get.height * 0.052,
          child: TextField(
            controller: searchTextController,
            decoration: fieldStyle.copyWith(
              hintText: "یہاں تلاش کریں",
              hintTextDirection: TextDirection.rtl,
              hintStyle: TextStyle(fontSize: height * 0.015),
              prefixIcon: const Icon(Icons.search, color: lightGrayColor),
              contentPadding: EdgeInsets.symmetric(
                  vertical: Get.height * 0.014, horizontal: Get.width * 0.03),
            ),
            textAlignVertical: TextAlignVertical.center,
            onChanged: (value) {
              productController.searchProducts(value);
            },
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Get.height * 0.01),
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
                        child: Text('کوئی پروڈکٹس نہیں ملے'),
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
