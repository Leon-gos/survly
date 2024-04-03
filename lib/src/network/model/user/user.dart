import 'dart:convert';

import 'package:survly/src/network/model/user_base/user_base.dart';

class User extends UserBase {
  final double balance;

  User({
    required super.fullname,
    required super.email,
    required super.avatar,
    required super.gender,
    required super.birthDate,
    required super.phone,
    super.role = UserBase.roleUser,
    required this.balance,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'balance': balance,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      fullname: map['fullname'] as String,
      email: map['email'] as String,
      avatar: map['avatar'] as String,
      gender: map['gender'] as String,
      birthDate: map['birthDate'] as String,
      phone: map['phone'] as String,
      balance: map['balance'] as double,
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);
}
