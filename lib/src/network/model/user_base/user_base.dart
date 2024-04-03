import 'dart:convert';

class UserBase {

  static const String roleAdmin = "admin";
  static const String roleUser = "user";

  final String fullname;
  final String email;
  final String avatar;
  final String gender;
  final String birthDate;
  final String phone;
  final String role;

  UserBase({
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
      fullname: map['fullname'] as String,
      email: map['email'] as String,
      avatar: map['avatar'] as String,
      gender: map['gender'] as String,
      birthDate: map['birthDate'] as String,
      phone: map['phone'] as String,
      role: map['role'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserBase.fromJson(String source) => UserBase.fromMap(json.decode(source) as Map<String, dynamic>);
}
