import 'package:agritech/models/product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/colors.dart';
import '../../../utils/contants.dart';
import '../controllers/company_controller.dart';

class EditProductScreen extends StatelessWidget {
  EditProductScreen({super.key});
  static const routeName = 'edit-product-screen';
  final List<String> productType = ['seed', 'tool', 'fertilizer'];
  final CompanyController controller = Get.put(CompanyController());
  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final product = Get.arguments as Product;
    controller.nameController.text = product.name;
    controller.descriptionController.text = product.description;
    controller.categoryController.text = product.category;
    controller.quantityController.text = product.stockCount.toString();
    controller.priceController.text = product.price.toString();
    controller.downloadImages(product.images);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "پروڈکٹ میں ترمیم کریں",
          style: textStyle,
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Get.width * 0.05, vertical: Get.width * 0.03),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'پروڈکٹ کا نام',
                  style: textStyle.copyWith(
                    fontSize: Get.height * 0.02,
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.015,
                ),
                TextFormField(
                  decoration: fieldStyle.copyWith(hintText: 'پروڈکٹ کا نام'),
                  controller: controller.nameController,
                  validator: (value) {
                    if (value == null) {
                      return 'نام کی ضرورت ہے';
                    } else if (value.length < 4) {
                      return 'پروڈکٹ کا درست نام درج کریں';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: Get.height * 0.015,
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
                  decoration: fieldStyle.copyWith(hintText: 'تفصیل درج کریں'),
                  controller: controller.descriptionController,
                  validator: (value) {
                    if (value == null) {
                      return 'تفصیل درکار ہے';
                    } else if (value.length < 10) {
                      return 'مصنوعات کی درست تفصیل درج کریں';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: Get.height * 0.015,
                ),
                Text(
                  'مصنوعات کی قسم',
                  style: textStyle.copyWith(
                    fontSize: Get.height * 0.02,
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.015,
                ),
                DropdownButtonFormField(
                  value: productType
                      .first, // Set the default value based on product.category
                  validator: (value) {
                    if (value == null) {
                      return 'زمرہ درکار ہے';
                    }
                    return null;
                  },
                  decoration: fieldStyle.copyWith(
                    focusColor: Colors.white,
                    fillColor: Colors.white,
                    hintText: 'قسم',
                  ),
                  items: productType.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      controller.categoryController.text = val;
                    }
                  },
                ),
                SizedBox(
                  height: Get.height * 0.015,
                ),
                Text(
                  'مصنوعات کی مقدار',
                  style: textStyle.copyWith(
                    fontSize: Get.height * 0.02,
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.015,
                ),
                TextFormField(
                  decoration: fieldStyle.copyWith(hintText: 'مقدار درج کریں'),
                  validator: (value) {
                    if (value == null) {
                      return 'quantity is required';
                    } else if (int.parse(value) < 0) {
                      return 'enter valid quantity of product';
                    }
                    return null;
                  },
                  controller: controller.quantityController,
                ),
                SizedBox(
                  height: Get.height * 0.015,
                ),
                Text(
                  'پروڈکٹ کی قیمت',
                  style: textStyle.copyWith(
                    fontSize: Get.height * 0.02,
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.015,
                ),
                TextFormField(
                  decoration: fieldStyle.copyWith(hintText: 'Rs.'),
                  controller: controller.priceController,
                  validator: (value) {
                    if (value == null) {
                      return 'price is required';
                    } else if (double.parse(value) < 0) {
                      return 'enter valid price of product';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: Get.height * 0.015,
                ),
                Text(
                  'مصنوعات کی تصاویر',
                  style: textStyle.copyWith(
                    fontSize: Get.height * 0.02,
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                Obx(
                  () => Container(
                    height: Get.height * 0.15,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                          style: BorderStyle.solid, color: lightGrayColor),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: controller.selectedImages.isEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.video_library,
                              size: Get.height * 0.06,
                            ),
                            onPressed: () {
                              controller.selectImagesFromGallery();
                            },
                          )
                        : SizedBox.expand(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.selectedImages.length,
                              itemBuilder: ((context, index) {
                                return Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    Image.file(
                                        controller.selectedImages[index]),
                                    Positioned(
                                        top: -10,
                                        right: -10,
                                        child: IconButton(
                                          icon: CircleAvatar(
                                            backgroundColor: primaryColor,
                                            radius: Get.height * 0.015,
                                            child: const Icon(
                                              Icons.close_rounded,
                                              color: Colors.red,
                                            ),
                                          ),
                                          onPressed: () {
                                            controller.selectedImages
                                                .removeAt(index);
                                          },
                                        ))
                                  ],
                                );
                              }),
                            ),
                          ),
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                SizedBox(
                  width: double.infinity,
                  height: Get.height * 0.06,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_key.currentState!.validate() &&
                          controller.selectedImages.isNotEmpty) {
                        controller.editProduct(
                            product.id,
                            controller.nameController.text,
                            controller.descriptionController.text,
                            double.parse(controller.priceController.text),
                            controller.categoryController.text,
                            int.parse(controller.quantityController.text),
                            product.reviewCount,
                            product.averageRating);
                      } else if (controller.selectedImages.isEmpty) {
                        Get.snackbar("خرابی", "کم از کم ایک تصویر منتخب کریں");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    child: Text(
                      "Edit Product",
                      style: textStyle.copyWith(
                          fontSize: Get.height * 0.02, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
