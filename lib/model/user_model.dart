class User {
  final String fullName;
  final String email;
  final String role;
  final String phone;

  User({
    required this.fullName,
    required this.email,
    required this.role,
    required this.phone,
  });

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "email": email,
        "role": role,
        "phone": phone,
      };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fullName: json["fullName"],
      email: json["email"],
      role: json["role"],
      phone: json["phone"],
    );
  }
}
