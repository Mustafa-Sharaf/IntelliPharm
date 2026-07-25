class UserModel {
  final String name;
  final String email;
  final List<String> roles;
  final List<String> permissions;
  final String? deviceToken;

  UserModel({
    required this.name,
    required this.email,
    required this.roles,
    required this.permissions,
    this.deviceToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, {String? fcmToken}) {
    return UserModel(
      name: json["name"] ?? '',
      email: json["email"] ?? '',
      roles: json["roles"] != null ? List<String>.from(json["roles"]) : [],
      permissions: json["permissions"] != null ? List<String>.from(json["permissions"]) : [],
      deviceToken: fcmToken,
    );
  }
}