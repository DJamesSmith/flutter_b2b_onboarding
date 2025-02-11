class User {
  final String userImg;
  final String fullName;
  final String email;
  final String role;
  final String phone;

  User({
    required this.fullName,
    required this.email,
    required this.role,
    required this.phone,
    required this.userImg,
  });

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "email": email,
        "role": role,
        "phone": phone,
        "userImg": userImg,
      };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fullName: json["fullName"],
      email: json["email"],
      role: json["role"],
      phone: json["phone"],
      userImg: json["userImg"],
    );
  }
}
