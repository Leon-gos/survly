import 'dart:convert';

import 'package:survly/src/network/model/user_base/user_base.dart';

class User extends UserBase {
  final int balance;
  final String intro;
  int? countDoing;
  int? countDone;

  User({
    required super.id,
    required super.fullname,
    required super.email,
    required super.avatar,
    required super.gender,
    required super.birthDate,
    required super.phone,
    super.role = UserBase.roleUser,
    required this.balance,
    required this.intro,
    this.countDoing,
    this.countDone,
  });

  factory User.newUser({required String email, required String fullname}) =>
      User(
        id: "",
        fullname: fullname,
        email: email,
        avatar: "",
        gender: "",
        birthDate: "",
        phone: "",
        balance: 0,
        intro: "",
      );

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ...super.toMap(),
      'balance': balance,
      'intro': intro,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id']?.toString() ?? "",
      fullname: map['fullname']?.toString() ?? "",
      email: map['email']?.toString() ?? "",
      avatar: map['avatar']?.toString() ?? "",
      gender: map['gender']?.toString() ?? UserBase.genderMale,
      birthDate: map['birthDate']?.toString() ?? "",
      phone: map['phone']?.toString() ?? "",
      balance: int.parse(map['balance']?.toString() ?? "0"),
      intro: map['intro']?.toString() ?? "",
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
