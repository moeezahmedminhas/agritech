import 'package:agritech/utils/contants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view_model/product_viewmodel.dart';

class CompanyController extends GetxController {
  static CompanyController get instance => Get.find();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  final productRepository = ProductRepository.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList selectedImages = [].obs;
  Rx<double> totalSales = 0.0.obs;
  Rx<int> totalOrders = 0.obs;
  final productMetric = "".obs;

  @override
  void onReady() {
    super.onReady();
    calculateMonthlyEarning();
  }

  void addProduct(String name, String description, double price,
      String category, int stockCount) {
    try {
      productRepository.addProduct(
          name, description, price, category, stockCount, selectedImages);
      nameController.text = '';
      descriptionController.text = '';
      quantityController.text = '';
      priceController.text = '';
      categoryController.text = '';
      selectedImages.clear();
    } catch (e) {
      Get.snackbar(
          "پروڈکٹ شامل نہیں کی گئی", "معذرت! مصنوعات کو شامل نہیں کیا جا سکتا");
    }
  }

  Future<double> calculateMonthlyEarning() async {
    // Calculate the start and end date of the current month
    // DateTime now = DateTime.now();
    // DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    // DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    // Query Firestore to retrieve completed orders within the current month
    QuerySnapshot querySnapshot = await _firestore
        .collection('orders')
        .where('status', isEqualTo: 'completed')
        .where('orderTo', isEqualTo: authUser.uid)
        // .where('orderDate', isGreaterThanOrEqualTo: firstDayOfMonth)
        // .where('orderDate', isLessThanOrEqualTo: lastDayOfMonth)
        .get();
    // Calculate the sum of totalAmount for the filtered orders
    double totalSaless = querySnapshot.docs.fold(0.0, (total, order) {
      return total + (order['totalAmount']);
    });
    totalSales.value = totalSaless;
    return totalSaless;
  }

  Future<int> countOrdersInProgress() async {
    // Query Firestore to retrieve orders with a status of "in process"
    QuerySnapshot querySnapshot = await _firestore
        .collection('orders')
        .where('status', isEqualTo: 'processing')
        .where('orderTo', isEqualTo: authUser.uid)
        .get();

    // Get the count of documents in the query result
    int count = querySnapshot.size;
    totalOrders.value = count;
    return count;
  }

  void editProduct(String id, String name, String description, double price,
      String category, int stockCount, int reviewCount, double averageRating) {
    try {
      productRepository.editProduct(id, name, description, price, category,
          stockCount, selectedImages, reviewCount, averageRating);
      nameController.text = '';
      descriptionController.text = '';
      quantityController.text = '';
      priceController.text = '';
      categoryController.text = '';
      selectedImages.clear();
    } catch (e) {
      Get.snackbar(
          "پروڈکٹ شامل نہیں کی گئی", "معذرت! مصنوعات کو شامل نہیں کیا جا سکتا");
    }
  }

  void selectImagesFromGallery() async {
    selectedImages.value = await productRepository.selectImagesFromGallery();
  }

  void downloadImages(List<String> urls) async {
    selectedImages.value = await productRepository.downloadImages(urls);
  }

  Future<List<String>> getUrls(String productId) async {
    List<String> images = await Future.wait(
      selectedImages.map((imagePath) async {
        return await productRepository.uploadImageToFirebaseStorage(
            imagePath, productId);
      }),
    );
    return images;
  }
}
