import 'package:agritech/models/cart_item.dart';

class Cart {
  final String id;
  final String userID;
  List<CartItem> items;

  Cart({
    required this.id,
    required this.userID,
    required this.items,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    final List<dynamic> itemsJson = json['items'] ?? [];
    List<CartItem> cartItems = itemsJson.map((itemJson) {
      return CartItem.fromJson(itemJson);
    }).toList();

    return Cart(
      id: json['id'] ?? "",
      userID: json['userID'] ?? "",
      items: cartItems,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> itemsJson =
        items.map((item) => item.toJson()).toList();

    return {
      'id': id,
      'userID': userID,
      'items': itemsJson,
    };
  }
}
