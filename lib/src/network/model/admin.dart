// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Admin {
  String? adminId;
  String fullname;
  String email;
  String avatar;
  String gender;
  String birthDate;
  String phone;

  Admin({
    this.adminId,
    required this.fullname,
    required this.email,
    required this.avatar,
    required this.gender,
    required this.birthDate,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'adminId': adminId,
      'fullname': fullname,
      'email': email,
      'avatar': avatar,
      'gender': gender,
      'birthDate': birthDate,
      'phone': phone,
    };
  }

  factory Admin.fromMap(Map<String, dynamic> map) {
    return Admin(
      adminId: map['adminId'] != null ? map['adminId'] as String : null,
      fullname: map['fullname'] as String,
      email: map['email'] as String,
      avatar: map['avatar'] as String,
      gender: map['gender'] as String,
      birthDate: map['birthDate'] as String,
      phone: map['phone'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Admin.fromJson(Map<String, dynamic> json) => Admin.fromMap(json);
}
