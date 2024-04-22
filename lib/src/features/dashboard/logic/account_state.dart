import 'package:equatable/equatable.dart';
import 'package:survly/src/network/model/admin/admin.dart';
import 'package:survly/src/network/model/user/user.dart';

import 'package:survly/src/network/model/user_base/user_base.dart';

class AccountState extends Equatable {
  final UserBase userBase;
  final UserBase userBaseClone;
  final String newAvtPath;

  const AccountState({
    required this.userBase,
    required this.userBaseClone,
    required this.newAvtPath,
  });

  factory AccountState.ds(UserBase userBase) {
    final clone = userBase.role == UserBase.roleUser
        ? (userBase as User).copyWith()
        : (userBase as Admin).copyWith();
    return AccountState(
      userBase: userBase,
      userBaseClone: clone,
      newAvtPath: "",
    );
  }

  @override
  List<Object?> get props => [
        userBase,
        userBaseClone,
        newAvtPath,
      ];

  AccountState copyWith({
    UserBase? userBase,
    UserBase? userBaseClone,
    String? newAvtPath,
  }) {
    return AccountState(
      userBase: userBase ?? this.userBase,
      userBaseClone: userBaseClone ?? this.userBaseClone,
      newAvtPath: newAvtPath ?? this.newAvtPath,
    );
  }
}
