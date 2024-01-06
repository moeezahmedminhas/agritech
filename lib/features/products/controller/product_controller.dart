import 'package:agritech/features/auth/controller/user_data_controller.dart';
import 'package:agritech/utils/contants.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../../models/review.dart';
import '../../cart/controller/cart_controller.dart';
import '../../../models/product.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.put(ProductController());
  final Rx<List<Product>> _products = Rx<List<Product>>([]);
  final Rx<List<Product>> _filteredProducts = Rx<List<Product>>([]);
  final UserDataController _userDataController = Get.put(UserDataController());
  List<Product> get products => _products.value;
  List<Product> get filteredProducts => _filteredProducts.value;
  final _firestore = FirebaseFirestore.instance;
  final reviewCommentController = TextEditingController();
  var isLoading = false.obs;
  var isSearching = false.obs;

  @override
  void onInit() async {
    super.onInit();
    _userDataController.getUserData().then((value) => {
          if (value.type == userTypes[0])
            {fetchProducts()}
          else
            {fetchProductsBy()}
        });
  }

  Future<double> calculateAverageRating(String productId) async {
    double totalRating = 0;
    int ratingCount = 0;

    var reviewsSnapshot = await _firestore
        .collection('reviews')
        .doc(productId)
        .collection('items')
        .get();

    for (var doc in reviewsSnapshot.docs) {
      Review review = Review.fromJson(doc.data());
      totalRating += review.rating;
      ratingCount++;
    }

    if (ratingCount == 0) {
      return 0.0;
    } else {
      return totalRating / ratingCount;
    }
  }

  Future<void> addReviewToProduct(
      {required String productID,
      required String comment,
      required double rating}) async {
    var reviewId = const Uuid().v1();
    _userDataController.getUserData().then((value) async {
      Review review = Review(
        id: reviewId,
        userID: value.fullName,
        rating: rating,
        comment: comment,
        date: DateTime.now(),
        productId: productID,
      );

      try {
        await _firestore
            .collection('reviews')
            .doc(productID)
            .collection('items')
            .add(review.toJson());
        reviewCommentController.text = "";
        final products = _firestore.collection('products');

        calculateAverageRating(productID).then((value) async {
          return await products.doc(productID).update({
            'reviewCount': FieldValue.increment(1),
            'averageRating': value,
          });
        });
        Get.back();

        Get.snackbar("ہو گیا", "کامیابی سے جائزہ لیا گیا۔");
      } catch (error) {
        Get.snackbar("غلطی", "جائزہ شامل کرنے میں خرابی");
      }
    });
  }

  Stream<List<Review>> loadReviewsForProduct(String productID) {
    try {
      Stream<QuerySnapshot> queryStream = _firestore
          .collection('reviews')
          .doc(productID)
          .collection('items')
          .orderBy('date',
              descending: true) // Order by the 'date' field in descending order
          .snapshots();

      Stream<List<Review>> reviewStream = queryStream.map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return Review.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
      });

      return reviewStream;
    } catch (error) {
      return const Stream<List<Review>>.empty();
    }
  }

  void fetchProductsBy() async {
    isLoading(true);
    try {
      final productCollection = _firestore.collection('products');
      final query = productCollection.where('productBy',
          isEqualTo: FirebaseAuth.instance.currentUser?.uid);

      query.snapshots().listen((snapshot) {
        _products.value =
            snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList();
        // If not searching, keep the filtered list in sync with all products
        if (!isSearching.value) {
          _filteredProducts.value = _products.value;
        }
        isLoading(false); // Set loading to false once products are fetched
      });
    } catch (e) {
      isLoading(false); // Set loading to false if an exception occurs
      rethrow; // Rethrow the exception for further handling if needed
    }
  }

  void fetchProducts() async {
    isLoading(true);
    try {
      final productCollection = _firestore.collection('products');
      productCollection.snapshots().listen((snapshot) {
        _products.value =
            snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList();
        // If not searching, keep the filtered list in sync with all products
        if (!isSearching.value) {
          _filteredProducts.value = _products.value;
        }
        isLoading(false); // Set loading to false once products are fetched
      });
    } catch (e) {
      isLoading(false); // Set loading to false if an exception occurs
      rethrow; // Rethrow the exception for further handling if needed
    }
  }

  // Search products based on a query
  void searchProducts(String query) {
    if (query.isEmpty) {
      _filteredProducts.value = _products.value;
      isSearching(false); // No active search
    } else {
      _filteredProducts.value = _products.value
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      isSearching(true); // Active search
    }
  }

  // Add a product to the cart
  void addProductToCart(Product product) {
    CartController.instance.addToCart(product);
  }
}

// Exception class for handling product
class ProductsException implements Exception {
  final String message;
  ProductsException(this.message);
}
