import 'package:equatable/equatable.dart';
import 'package:survly/src/network/model/admin/admin.dart';
import 'package:survly/src/network/model/user/user.dart';

import 'package:survly/src/network/model/user_base/user_base.dart';

class AccountState extends Equatable {
  final UserBase? userBase;
  final UserBase? userBaseClone;
  final String newAvtPath;
  final bool isLoading;

  const AccountState({
    required this.userBase,
    required this.userBaseClone,
    required this.newAvtPath,
    required this.isLoading,
  });

  factory AccountState.ds() {
    return const AccountState(
      userBase: null,
      userBaseClone: null,
      newAvtPath: "",
      isLoading: false,
    );
  }

  UserBase cloneUserbase() {
    return userBase?.role == UserBase.roleUser
        ? (userBase as User).copyWith()
        : (userBase as Admin).copyWith();
  }

  @override
  List<Object?> get props => [
        userBase,
        userBaseClone,
        newAvtPath,
        isLoading,
      ];

  AccountState copyWith({
    UserBase? userBase,
    UserBase? userBaseClone,
    String? newAvtPath,
    bool? isLoading,
  }) {
    return AccountState(
      userBase: userBase ?? this.userBase,
      userBaseClone: userBaseClone ?? this.userBaseClone,
      newAvtPath: newAvtPath ?? this.newAvtPath,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  bool get isUser {
    return userBaseClone is User;
  }

  bool get isAdmin {
    return userBaseClone is Admin;
  }
}
