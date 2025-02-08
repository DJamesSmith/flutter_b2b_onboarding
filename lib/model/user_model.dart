class UserProfile {
  final String fullName;
  final String email;
  final String role;

  UserProfile({
    required this.fullName,
    required this.email,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "email": email,
        "role": role,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      fullName: json["fullName"],
      email: json["email"],
      role: json["role"],
    );
  }
}
