import 'dart:async';

import 'package:agritech/features/auth/controller/user_data_controller.dart';
import 'package:agritech/features/cart/controller/cart_controller.dart';
import 'package:agritech/models/cart_item.dart';
import 'package:agritech/models/order.dart';
import 'package:agritech/utils/contants.dart';
import 'package:agritech/utils/order_enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../../models/user.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.put(OrderController());
  final deliveryCharges = 200.obs;
  final CartController cartController = Get.put(CartController.instance);

  final _firestore = firestore.FirebaseFirestore.instance;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<OrderStatusEnum> selectedStatus =
      OrderStatusEnum.processing.obs; // Default status
  final _firebaseAuth = FirebaseAuth.instance;
  @override
  void onInit() {
    super.onInit();
    UserDataController.instance.getUserData();
  }

  Future<void> selectDate(BuildContext context, String orderId) async {
    // Set the initial date to the current date.

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000), // Specify the earliest selectable date.
      lastDate: DateTime(2101), // Specify the latest selectable date.
    );

    if (picked != null && picked != selectedDate.value) {
      // If a date is picked, update the selectedDate variable.
      OrderController.instance.updateOrderDelivery(
          orderId, OrderController.instance.selectedDate.value, null);
      selectedDate.value = picked;
    }
  }

  // void addOrder({required totalAmount}) {
  //   var uuid = const Uuid().v4();

  //   final order = Order(
  //       id: uuid,
  //       userID: FirebaseAuth.instance.currentUser!.uid,
  //       products: cartController.cartItems,
  //       totalAmount: totalAmount,
  //       orderDate: DateTime.now(),
  //       deliveryDate: DateTime.now().add(const Duration(days: 7)),
  //       status: OrderStatusEnum.processing);
  //   _firestore.collection('orders').doc(uuid).set(order.toJson());

  //   _firestore.collection('cart').doc(_firebaseAuth.currentUser!.uid).delete();
  //   cartController.cartItems.clear();
  // }

  void addOrder({required item, required totalAmount}) {
    var uuid = const Uuid().v4();
    List<CartItem> items = item;
    final order = Order(
        id: uuid,
        userID: FirebaseAuth.instance.currentUser!.uid,
        products: items,
        totalAmount: totalAmount,
        orderDate: DateTime.now(),
        deliveryDate: DateTime.now().add(const Duration(days: 7)),
        status: OrderStatusEnum.processing,
        orderTo: items[0].productBy);
    _firestore.collection('orders').doc(uuid).set(order.toJson());
  }

  void updateOrderDelivery(
      String orderId, DateTime? deliveryDate, String? status) {
    try {
      if (status != null && deliveryDate != null) {
        _firestore.collection('orders').doc(orderId).update(
            {'deliveryDate': deliveryDate.toIso8601String(), 'status': status});
        Get.snackbar("آرڈر کو کامیابی کے ساتھ اپ ڈیٹ کر دیا گیا",
            "$deliveryDate  : ادئیگی کی تاریخ|  $status : حالت");
      } else if (status == null) {
        _firestore
            .collection('orders')
            .doc(orderId)
            .update({'deliveryDate': deliveryDate});
        Get.snackbar("آرڈر کو کامیابی کے ساتھ اپ ڈیٹ کر دیا گیا",
            "$deliveryDate  : ادئیگی کی تاریخ");
      } else if (deliveryDate == null) {
        _firestore.collection('orders').doc(orderId).update({'status': status});
        Get.snackbar(
            "آرڈر کو کامیابی کے ساتھ اپ ڈیٹ کر دیا گیا", "$status  : حالت");
      }
    } catch (e) {
      Get.snackbar("خرابی", "آرڈر کو اپ ڈیٹ کرنے میں خرابی");
    }
  }

  Stream<List<Order>> getUserOrdersStream(OrderStatusEnum status) {
    final StreamController<List<Order>> controller = StreamController();
    final query = _firestore
        .collection("orders")
        .where("userID", isEqualTo: _firebaseAuth.currentUser!.uid)
        .where("status", isEqualTo: status.status) // Filter by status
        .snapshots();

    query.listen((event) {
      final List<Order> orders = [];
      for (var doc in event.docs) {
        orders.add(Order.fromJson(doc.data()));
      }
      controller.add(orders); // Add the list of orders to the stream
    });

    return controller.stream;
  }

  // Stream<Order> getOrder() {}
  Stream<List<Order>> getCompanyOrdersStream(OrderStatusEnum status) {
    final StreamController<List<Order>> controller = StreamController();
    final query = _firestore
        .collection("orders")
        .where("status", isEqualTo: status.status) // Filter by status
        .where("orderTo",
            isEqualTo: authUser.uid) // Additionally filter by order ID
        .snapshots();

    query.listen((event) {
      final List<Order> orders = [];
      for (var doc in event.docs) {
        orders.add(Order.fromJson(doc.data()));
      }
      controller.add(orders); // Add the list of orders to the stream
    });

    return controller.stream;
  }

  Future<AppUser?> getUserDataById(String userId) async {
    final userData = await _firestore.collection("users").doc(userId).get();
    AppUser? user;

    if (userData.data() != null) {
      user = AppUser.fromJson(userData.data()!);
    }
    return user;
  }
}
