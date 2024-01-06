import 'package:agritech/features/order/controller/order_controller.dart';
import 'package:agritech/features/products/controller/product_controller.dart';
import 'package:agritech/models/cart.dart';
import 'package:agritech/models/product.dart';
import 'package:agritech/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/cart_item.dart';
import '../../../utils/cutom_alert.dart';
import '../../order/screens/order_screen.dart';

class CartController extends GetxController {
  static CartController get instance => Get.put(CartController());
  final _fireStore = FirebaseFirestore.instance;
  final _firebaseAuth = FirebaseAuth.instance;
  final ProductController controller = ProductController.instance;
  final cartRef = FirebaseFirestore.instance.collection('cart');
  static Rx<Cart?> userCart = Rx<Cart?>(null);
  static late Rxn<AppUser> user;
  RxList<CartItem> cartItems = <CartItem>[].obs;
  var isLoading = true.obs;
  Future<void> fetchCart(String userId) async {
    final doc = await cartRef.doc(userId).get();
    if (doc.exists) {
      userCart.value = Cart.fromJson(doc.data()!);
    } else {
      userCart.value = Cart(id: userId, userID: userId, items: []);
    }
  }

  void addRemoveCartItem(int index, String operation) async {
    final documentReference = cartRef.doc(_firebaseAuth.currentUser!.uid);
    final documentSnapshot = await documentReference.get();

    if (documentSnapshot.exists) {
      int indexProduct = controller.products
          .indexWhere((element) => element.id == cartItems[index].productID);
      if (index >= 0 && index < cartItems.length) {
        if (operation == '+') {
          if (cartItems[index].quantity <
              controller.products[indexProduct].stockCount) {
            cartItems[index].quantity += 1;
            cartItems[index].totalPrice =
                cartItems[index].quantity * cartItems[index].unitPrice;
          } else {
            Get.snackbar("زخیرے سے باہر", "اتنی مقدار میں دستیاب نہ ہو");
          }
        } else if (operation == '-') {
          if (cartItems[index].quantity - 1 > 0) {
            cartItems[index].quantity -= 1;
            cartItems[index].totalPrice =
                cartItems[index].quantity * cartItems[index].unitPrice;
          } else {
            cartItems.removeAt(index);
          }
        } else if (operation == 'del') {
          cartItems.removeAt(index);
        }

        await documentReference
            .update({'items': cartItems.map((e) => e.toJson())});
        cartItems.refresh();
      }
    }
  }

  addItem(CartItem newItem) async {
    var existingItemIndex = userCart.value!.items.indexWhere(
      (item) => item.productID == newItem.productID,
    );
    if (existingItemIndex != -1) {
      addRemoveCartItem(existingItemIndex, '+');
    } else {
      userCart.value!.items.add(newItem);
    }
  }

  void verifyItems() {
    bool inStock = true;
    for (CartItem item in cartItems) {
      int indexProduct = controller.products
          .indexWhere((element) => element.id == item.productID);
      if (item.quantity > controller.products[indexProduct].stockCount) {
        inStock = false;
        break;
      }
    }
    if (inStock) {
      Get.toNamed(OrderScreen.routeName);
    } else {
      Get.snackbar("زخیرے سے باہر", "اسٹاک میں مقدار کو منتخب کریں");
    }
  }

  Future<void> subtractItems(
      BuildContext context, Size screenSize, double totalAmount) async {
    final products = _fireStore.collection('products');
    final orderController = Get.find<OrderController>();
    final outOfStockItems = <CartItem>[];
    var copyOfItems = List.from(cartItems);

    for (CartItem item in copyOfItems) {
      final product = controller.products
          .firstWhere((element) => element.id == item.productID);

      if (item.quantity <= product.stockCount) {
        await products.doc(item.productID).update({
          'stockCount': FieldValue.increment(-item.quantity),
        });
      }
    }

    if (outOfStockItems.isEmpty) {
      for (CartItem item in copyOfItems) {
        orderController.addOrder(item: [item], totalAmount: item.totalPrice);
        cartItems.remove(item);
      }
      // All items were successfully subtracted from stock.
      // Proceed with order placement and UI updates.
      // orderController.addOrder(totalAmount: totalAmount);
      Get.back();
      if (!context.mounted) return;
      customAlertDialog(
        context,
        screenSize,
        'آرڈر دیا گیا',
        'آپ کو یہ 7 دنوں میں مل جائے گا۔ ادائیگی کا طریقہ: کیش آن ڈیلیوری',
      );

      cartRef.doc(_firebaseAuth.currentUser!.uid).delete();
    } else {
      // Some items were out of stock.
      // Display a notification or handle it accordingly.
      Get.snackbar("زخیرے سے باہر", "اسٹاک میں مقدار کو منتخب کریں");
    }
  }

  void addToCart(Product product) async {
    await fetchCart(_firebaseAuth.currentUser!.uid);
    CartItem newItem = CartItem(
        productID: product.id,
        productImage: product.images[0],
        productName: product.name,
        quantity: 1,
        unitPrice: product.price,
        totalPrice: 1 * product.price,
        productBy: product.productBy);
    try {
      await addItem(newItem);
      await cartRef.doc(userCart.value!.id).set(userCart.value!.toJson());
      Get.snackbar("ہو گیا", 'پروڈکٹ کو کارٹ میں شامل کیا گیا',
          snackPosition: SnackPosition.TOP);
    } catch (e) {
      Get.snackbar("شامل نہیں کیا گیا", "کارٹ میں شامل نہیں کیا گیا");
    }
  }

  Future<void> fetchCartItems() async {
    try {
      final querySnapshot = await _fireStore
          .collection('cart')
          .doc(_firebaseAuth.currentUser!.uid)
          .get();

      final cartData = Cart.fromJson(querySnapshot.data()!);

      cartItems.assignAll(cartData.items);

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;

      // Handle any errors or exceptions.
    }
  }
}
