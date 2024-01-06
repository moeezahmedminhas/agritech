class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final List<String> images;
  final int stockCount;
  final double averageRating;
  final int reviewCount;
  final String productBy;
  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.images,
    required this.stockCount,
    required this.averageRating,
    required this.reviewCount,
    required this.productBy,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      description: json['description'] ?? "",
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] ?? "",
      images: List<String>.from(json['images'] ?? []),
      stockCount: json['stockCount'] as int? ?? 0,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      productBy: json['productBy'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'images': images,
      'stockCount': stockCount,
      'averageRating': averageRating,
      'reviewCount': reviewCount,
      'productBy': productBy,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? category,
    List<String>? images,
    int? stockCount,
    double? averageRating,
    int? reviewCount,
    String? productBy,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      images: images ?? List.from(this.images),
      stockCount: stockCount ?? this.stockCount,
      averageRating: averageRating ?? this.averageRating,
      reviewCount: reviewCount ?? this.reviewCount,
      productBy: productBy ?? this.productBy,
    );
  }
}
