class CartItem {
  final String productID;
  final String productImage;
  final String productName;
  int quantity;
  final double unitPrice;
  double totalPrice;
  final String productBy;

  CartItem(
      {required this.productID,
      required this.productImage,
      required this.productName,
      required this.quantity,
      required this.unitPrice,
      required this.totalPrice,
      required this.productBy});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productID: json['productID'],
      productImage: json['productImage'],
      productName: json['productName'],
      quantity: json['quantity'],
      unitPrice: json['unitPrice'].toDouble(),
      totalPrice: json['totalPrice'].toDouble(),
      productBy: json['productBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productID': productID,
      'productImage': productImage,
      'productName': productName,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'productBy': productBy
    };
  }
}
