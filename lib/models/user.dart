class UserModel {
  UserModel({required this.id, required this.name, required this.email});
  final int id;
  final String name;
  final String email;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] ?? '',
        name: json['nama'],
        email: json['email'],
      );
}
