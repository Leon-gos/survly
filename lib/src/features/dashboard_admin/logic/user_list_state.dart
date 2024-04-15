import 'package:equatable/equatable.dart';
import 'package:survly/src/network/model/user/user.dart';

class UserListState extends Equatable {
  final List<User> userList;
  final bool isLoading;

  const UserListState({
    required this.userList,
    required this.isLoading,
  });

  factory UserListState.ds() => const UserListState(
        userList: [],
        isLoading: true,
      );

  UserListState copyWith({
    List<User>? userList,
    bool? isLoading,
  }) {
    return UserListState(
      userList: userList ?? this.userList,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [userList, isLoading];
}
