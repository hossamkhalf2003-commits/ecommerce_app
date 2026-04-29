class UserModel {
  final int id;
  final String email;
  final String name;
  final String role;
  final String avatar;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.avatar,
  });

  // This factory translates the JSON from the internet into our Dart object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      role: json['role'],
      avatar: json['avatar'],
    );
  }
}