import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:survly/src/config/constants/firebase_collections.dart';

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
  final DateTime birthDate;
  final String phone;
  final String role;
  final String? fcmToken;

  UserBase({
    required this.id,
    required this.fullname,
    required this.email,
    required this.avatar,
    required this.gender,
    required this.birthDate,
    required this.phone,
    required this.role,
    this.fcmToken,
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
      'fcmToken': fcmToken,
    };
  }

  factory UserBase.fromMap(Map<String, dynamic> map) {
    return UserBase(
      id: map['id']?.toString() ?? "",
      fullname: map['fullname']?.toString() ?? "",
      email: map['email']?.toString() ?? "",
      avatar: map['avatar']?.toString() ?? "",
      gender: map['gender']?.toString() ?? genderMale,
      birthDate: (map['birthDate'] as Timestamp).toDate(),
      phone: map['phone']?.toString() ?? "",
      role: map['role']?.toString() ?? roleUser,
      fcmToken: map['fcmToken']?.toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserBase.fromJson(String source) =>
      UserBase.fromMap(json.decode(source) as Map<String, dynamic>);

  UserBase copyWith({
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
    return UserBase(
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

  String genAvatarFileKey() {
    return "${UserCollection.fieldAvatar}/$id";
  }
}
