import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
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
      birthDate: (map['birthDate'] as Timestamp).toDate(),
      phone: map['phone']?.toString() ?? "",
      fcmToken: map['fcmToken']?.toString(),
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory Admin.fromJson(String source) =>
      Admin.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  Admin copyWith({
    String? id,
    String? fullname,
    String? email,
    String? avatar,
    String? gender,
    DateTime? birthDate,
    String? phone,
    String? role,
    String? fcmToken,
  }) {
    return Admin(
      id: id ?? this.id,
      fullname: fullname ?? this.fullname,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }
}
