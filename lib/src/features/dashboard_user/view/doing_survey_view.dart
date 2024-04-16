import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:survly/src/features/dashboard_user/logic/user_list_bloc.dart';
import 'package:survly/src/features/dashboard_user/logic/user_list_state.dart';
import 'package:survly/src/features/dashboard_user/widget/user_list_widget.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/router/router_name.dart';
import 'package:survly/widgets/app_loading_circle.dart';
import 'package:survly/widgets/app_text_field.dart';

class DoingSurvey extends StatelessWidget {
  const DoingSurvey({super.key});

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
      buildWhen: (previous, current) => previous.userList != current.userList,
      builder: (context, state) {
        return Expanded(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: AppTextField(
                  hintText: S.of(context).labelSearch,
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
              Expanded(
                flex: 1,
                child: UserListWidget(
                  userList: state.userList,
                  onItemClick: (user) {
                    context.push(AppRouteNames.userProfile.path, extra: user);
                  },
                  onLoadMore: context.read<UserListBloc>().fetchUserNexPage,
                  onRefresh: context.read<UserListBloc>().fetchUserFirstPage,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
