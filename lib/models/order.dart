import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agritech/models/cart_item.dart';
import 'package:agritech/utils/order_enum.dart';

class Order {
  final String id;
  final String userID;
  final List<CartItem> products;
  final double totalAmount;
  final DateTime orderDate;
  final DateTime deliveryDate;
  final OrderStatusEnum status;
  final String orderTo;

  Order(
      {required this.id,
      required this.userID,
      required this.products,
      required this.totalAmount,
      required this.orderDate,
      required this.deliveryDate,
      required this.status,
      required this.orderTo});

  factory Order.fromJson(Map<String, dynamic> json) {
    List<dynamic> productsJson = json['products'] as List<dynamic>? ?? [];
    List<CartItem> cartItems = productsJson.map((itemJson) {
      return CartItem.fromJson(itemJson as Map<String, dynamic>);
    }).toList();

    DateTime orderDate = _convertTimestampToDate(json['orderDate']);
    DateTime deliveryDate = _convertTimestampToDate(json['deliveryDate']);

    return Order(
      id: json['id'] ?? "",
      userID: json['userID'] ?? "",
      products: cartItems,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      orderDate: orderDate,
      deliveryDate: deliveryDate,
      status: (json['status'] as String).toEnum(),
      orderTo: json['orderTo'] ?? "",
    );
  }

  static DateTime _convertTimestampToDate(dynamic dateField) {
    if (dateField is Timestamp) {
      return dateField.toDate();
    } else if (dateField is String) {
      return DateTime.parse(dateField);
    } else {
      return DateTime
          .now(); // Default to current time if the field is neither Timestamp nor String
    }
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> productsJson =
        products.map((product) => product.toJson()).toList();

    return {
      'id': id,
      'userID': userID,
      'products': productsJson,
      'totalAmount': totalAmount,
      'orderDate': orderDate.toIso8601String(),
      'deliveryDate': deliveryDate.toIso8601String(),
      'status': status.status,
      'orderTo': orderTo,
    };
  }
}
