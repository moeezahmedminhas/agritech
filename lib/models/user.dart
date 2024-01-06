class AppUser {
  final String id;
  final String fullName;
  final String profilePic;
  final String type;
  final String email;
  final String address;
  final String phone;
  final String postalCode;

  AppUser(
      {required this.id,
      required this.profilePic,
      required this.fullName,
      required this.type,
      required this.email,
      required this.address,
      required this.phone,
      required this.postalCode});

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] ?? "",
      fullName: json['fullName'] ?? "",
      email: json['email'] ?? "",
      address: json['address'] ?? "",
      type: json['type'] ?? "",
      phone: json['phone'] ?? "",
      postalCode: json['postalCode'] ?? "",
      profilePic: json['profilePic'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'address': address,
      'phone': phone,
      'postalCode': postalCode,
      'profilePic': profilePic,
      'type': type
    };
  }
}
