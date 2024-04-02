import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin.freezed.dart';
// part 'admin.g.dart';

@freezed
class Admin with _$Admin {
  // String? adminId;
  // String fullname;
  // String email;
  // String avatar;
  // String gender;
  // String birthDate;
  // String phone;

  // // Admin({
  // //   this.adminId,
  // //   required this.fullname,
  // //   required this.email,
  // //   required this.avatar,
  // //   required this.gender,
  // //   required this.birthDate,
  // //   required this.phone,
  // // });

  const factory Admin({
    String? adminId,
    required String fullname,
    required String email,
    required String avatar,
    required String gender,
    required String birthDate,
    required String phone,
  }) = _Admin;

  factory Admin.fromJson(Map<String, Object?> json) => _$AdminFromJson(json);

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'adminId': adminId,
  //     'fullname': fullname,
  //     'email': email,
  //     'avatar': avatar,
  //     'gender': gender,
  //     'birthDate': birthDate,
  //     'phone': phone,
  //   };
  // }

  // factory Admin.fromMap(Map<String, dynamic> map) {
  //   return Admin(
  //     adminId: map['adminId'] != null ? map['adminId'] as String : null,
  //     fullname: map['fullname'] as String,
  //     email: map['email'] as String,
  //     avatar: map['avatar'] as String,
  //     gender: map['gender'] as String,
  //     birthDate: map['birthDate'] as String,
  //     phone: map['phone'] as String,
  //   );
  // }

  // String toJson() => json.encode(toMap());

  // factory Admin.fromJson(Map<String, Object?> json) => Admin.fromMap(json);
}
