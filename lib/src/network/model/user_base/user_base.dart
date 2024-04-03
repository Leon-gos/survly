import 'dart:convert';

class UserBase {
  static const String roleAdmin = "admin";
  static const String roleUser = "user";
  static const String genderMale = "male";
  static const String genderFemale = "female";

  final String id;
  final String fullname;
  final String email;
  final String avatar;
  final String gender;
  final String birthDate;
  final String phone;
  final String role;

  UserBase({
    required this.id,
    required this.fullname,
    required this.email,
    required this.avatar,
    required this.gender,
    required this.birthDate,
    required this.phone,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fullname': fullname,
      'email': email,
      'avatar': avatar,
      'gender': gender,
      'birthDate': birthDate,
      'phone': phone,
      'role': role,
    };
  }

  factory UserBase.fromMap(Map<String, dynamic> map) {
    return UserBase(
      id: map['id']?.toString() ?? "",
      fullname: map['fullname']?.toString() ?? "",
      email: map['email']?.toString() ?? "",
      avatar: map['avatar']?.toString() ?? "",
      gender: map['gender']?.toString() ?? genderMale,
      birthDate: map['birthDate']?.toString() ?? "",
      phone: map['phone']?.toString() ?? "",
      role: map['role']?.toString() ?? roleUser,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserBase.fromJson(String source) =>
      UserBase.fromMap(json.decode(source) as Map<String, dynamic>);
}
