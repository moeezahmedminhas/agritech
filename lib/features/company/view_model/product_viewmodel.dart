import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class ProductRepository extends GetxController {
  static ProductRepository get instance => Get.put(ProductRepository());

  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final _fireAuth = FirebaseAuth.instance;
  Future<void> addProduct(String name, String description, double price,
      String category, int stockCount, List selectedImages) async {
    final products = _firestore.collection('products');
    var productId = const Uuid().v1();
    List<String> images = await Future.wait(
      selectedImages.map((imagePath) async {
        return await uploadImageToFirebaseStorage(imagePath, productId);
      }),
    );
    Product product = Product(
        id: productId, // this will be generated by Firestore when adding
        name: name,
        description: description,
        price: price,
        category: category,
        images: images,
        stockCount: stockCount,
        averageRating: 0,
        reviewCount: 0,
        productBy: _fireAuth.currentUser!.uid);
    try {
      await products.doc(productId).set(product.toJson());
      Get.snackbar("Product Added", "Successfully",
          snackPosition: SnackPosition.BOTTOM);
      // print('Product added successfully!');
    } catch (e) {
      // print('Failed to add product: $e');
    }
  }

  Future<void> editProduct(
      String id,
      String name,
      String description,
      double price,
      String category,
      int stockCount,
      List selectedImages,
      int reviewCount,
      double averageRating) async {
    final products = _firestore.collection('products');
    List<String> images = await Future.wait(
      selectedImages.map((imagePath) async {
        return await uploadImageToFirebaseStorage(imagePath, id);
      }),
    );
    Product product = Product(
        id: id,
        name: name,
        description: description,
        price: price,
        category: category,
        images: images,
        stockCount: stockCount,
        averageRating: averageRating,
        reviewCount: reviewCount,
        productBy: _fireAuth.currentUser!.uid);
    try {
      await products.doc(id).set(product.toJson());
      Get.snackbar("Successfully", "Product Modified",
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error ", "Modifying Product",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<List<File>> selectImagesFromGallery() async {
    final picker = ImagePicker(); // Instance of Image picker
    List<File> selectedImages = [];

    final pickFiles = await picker.pickMultiImage(
      maxHeight: Get.height * 0.4,
      maxWidth: Get.width * 0.3,
    );
    selectedImages = pickFiles.map((e) => File(e.path)).toList();
    return selectedImages;
  }

  Future<List<File>> downloadImages(List<String> imageUrls) async {
    List<File> imageFiles = [];

    for (String imageUrl in imageUrls) {
      try {
        var response = await http.get(Uri.parse(imageUrl));
        if (response.statusCode == 200) {
          // Get the document directory path
          final appDirectory = await getApplicationDocumentsDirectory();

          // Generate a unique file name for each image
          String fileName = DateTime.now().millisecondsSinceEpoch.toString();

          // Create the file and write the image data
          File imageFile = File('${appDirectory.path}/$fileName.png');
          await imageFile.writeAsBytes(response.bodyBytes);

          imageFiles.add(imageFile);
        }
      } catch (e) {
        Get.snackbar("Error", "Downloading images");
      }
    }

    return imageFiles;
  }

  Future<String> uploadImageToFirebaseStorage(
      File imageFile, String productId) async {
    Reference ref =
        _storage.ref('products/$productId/${DateTime.now().toIso8601String()}');
    UploadTask uploadTask = ref.putFile(imageFile);

    await uploadTask.whenComplete(() => {});
    String downloadUrl = await ref.getDownloadURL();
    return downloadUrl;
  }
}
