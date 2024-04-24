import 'dart:convert';

import 'package:survly/src/network/model/user_base/user_base.dart';

class Admin extends UserBase {
  Admin({
    required super.id,
    required super.fullname,
    required super.email,
    required super.avatar,
    required super.gender,
    required super.birthDate,
    required super.phone,
    super.role = UserBase.roleAdmin,
    super.fcmToken,
  });

  factory Admin.fromMap(Map<String, dynamic> map) {
    return Admin(
      id: map['id']?.toString() ?? "",
      fullname: map['fullname']?.toString() ?? "",
      email: map['email']?.toString() ?? "",
      avatar: map['avatar']?.toString() ?? "",
      gender: map['gender']?.toString() ?? UserBase.genderMale,
      birthDate: map['birthDate']?.toString() ?? "",
      phone: map['phone']?.toString() ?? "",
      fcmToken: map['fcmToken']?.toString(),
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory Admin.fromJson(String source) =>
      Admin.fromMap(json.decode(source) as Map<String, dynamic>);
}
