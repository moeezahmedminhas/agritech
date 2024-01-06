import 'package:agritech/features/company/controllers/company_controller.dart';
import 'package:agritech/utils/contants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/colors.dart';

class AddProductScreen extends StatelessWidget {
  static const routeName = '/add-product-screen';
  AddProductScreen({super.key});
  final CompanyController controller = Get.put(CompanyController());
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    controller.nameController.text = "";
    controller.descriptionController.text = "";
    controller.categoryController.text = "";
    controller.quantityController.text = "";
    controller.priceController.text = "";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "پروڈکٹ شامل کریں",
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
                  decoration: fieldStyle.copyWith(hintText: 'تفصیل درج کریں۔'),
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
                  validator: (value) {
                    if (value == null) {
                      return 'زمرہ درکار ہے';
                    }
                    return null;
                  },
                  decoration: fieldStyle.copyWith(
                      focusColor: Colors.white,
                      fillColor: Colors.white,
                      hintText: 'قسم'),
                  items: productType.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      controller.categoryController.text = val;
                      if (controller.categoryController.text ==
                              productType[0] ||
                          controller.categoryController.text ==
                              productType[2]) {
                        controller.productMetric.value = '/kg';
                      } else {
                        controller.productMetric.value = '/item';
                      }
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
                  decoration: fieldStyle.copyWith(
                      hintText: 'مقدار درج کریں',
                      suffixIcon: Obx(() => Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(controller.productMetric.value),
                            ],
                          ))),
                  validator: (value) {
                    if (value == null) {
                      return 'مقدار کی ضرورت ہے';
                    } else if (int.parse(value) < 0) {
                      return 'مصنوعات کی درست مقدار درج کریں';
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
                      return 'قیمت کی ضرورت ہے';
                    } else if (double.parse(value) < 0) {
                      return 'مصنوعات کی درست قیمت درج کریں';
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
                                return Image.file(
                                    controller.selectedImages[index]);
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
                        controller.addProduct(
                            controller.nameController.text,
                            controller.descriptionController.text,
                            double.parse(controller.priceController.text),
                            controller.categoryController.text,
                            int.parse(controller.quantityController.text));
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
                      "پروڈکٹ شامل کریں",
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
