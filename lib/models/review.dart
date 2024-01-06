class Review {
  final String id;
  final String userID;
  final double rating;
  final String comment;
  final DateTime date;
  final String productId;

  Review(
      {required this.id,
      required this.userID,
      required this.rating,
      required this.comment,
      required this.date,
      required this.productId});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? "",
      userID: json['userID'] ?? "",
      rating: json['rating'] as double? ?? 0.0,
      comment: json['comment'] ?? "",
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      productId: json['productId'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userID': userID,
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(),
      'productId': productId
    };
  }
}
