import 'dart:convert';

import 'package:survly/src/network/model/user_base/user_base.dart';

class Admin extends UserBase {
  Admin({
    required super.fullname,
    required super.email,
    required super.avatar,
    required super.gender,
    required super.birthDate,
    required super.phone,
    required super.role,
  });

  factory Admin.fromMap(Map<String, dynamic> map) {
    return Admin(
      fullname: map['fullname'] as String,
      email: map['email'] as String,
      avatar: map['avatar'] as String,
      gender: map['gender'] as String,
      birthDate: map['birthDate'] as String,
      phone: map['phone'] as String,
      role: map['role'],
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory Admin.fromJson(String source) => Admin.fromMap(json.decode(source) as Map<String, dynamic>);
}
