
class UserModel {
 // final int id;
  final String name;
  final String email;
  final List<String> roles;
  final List<String> permissions;

  UserModel({
   // required this.id,
    required this.name,
    required this.email,
    required this.roles,
    required this.permissions,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
     // id: json["id"],
      name: json["name"],
      email: json["email"],
      roles: List<String>.from(json["roles"]),
      permissions: List<String>.from(json["permissions"]),
    );
  }
}