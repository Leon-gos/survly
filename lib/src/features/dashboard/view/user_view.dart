import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/src/features/dashboard/logic/user_list_bloc.dart';
import 'package:survly/src/features/dashboard/logic/user_list_state.dart';
import 'package:survly/src/features/dashboard/widget/user_card.dart';
import 'package:survly/src/network/model/user/user.dart';
import 'package:survly/widgets/app_loading_circle.dart';

class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserListBloc(),
      child: BlocBuilder<UserListBloc, UserListState>(
        buildWhen: (previous, current) =>
            previous.isLoading != current.isLoading,
        builder: (context, state) {
          return Scaffold(
            body: state.isLoading
                ? const AppLoadingCircle()
                : Column(
                    children: [
                      _buildUserList(),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget _buildUserList() {
    return BlocBuilder<UserListBloc, UserListState>(
      buildWhen: (previous, current) => false,
      builder: (context, state) {
        return Expanded(
          child: ListView.builder(
            itemCount: state.userList.length,
            itemBuilder: (context, index) {
              User user = state.userList[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: UserCard(
                  user: user,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
