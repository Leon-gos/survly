import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:survly/src/features/dashboard/logic/account_bloc.dart';
import 'package:survly/src/features/dashboard/logic/account_state.dart';
import 'package:survly/src/features/dashboard_user/logic/bottom_nav_bloc.dart';
import 'package:survly/src/features/dashboard_user/logic/navigation_bar_item.dart';
import 'package:survly/src/features/dashboard_user/widget/bottom_navigation_bar.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/router/router_name.dart';
import 'package:survly/src/theme/colors.dart';
import 'package:survly/widgets/app_app_bar.dart';
import 'package:survly/widgets/app_avatar_widget.dart';

class DashboardUserScreen extends StatelessWidget {
  final Widget body;
  final UserBottomNavBarItems currentItem;

  const DashboardUserScreen(
      {super.key, required this.body, required this.currentItem});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavBloc(currentItem),
      child: _buildDashboardScreen(context),
    );
  }

  Widget _buildDashboardScreen(BuildContext context) {
    return BlocBuilder<BottomNavBloc, UserBottomNavBarItems>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppAppBarWidget(
            noActionBar: true,
            backgroundColor: AppColors.backgroundBrightness,
          ),
          body: Column(
            children: [
              _buildUserInfo(context),
              Expanded(child: body),
            ],
          ),
          bottomNavigationBar: const UserBottomNavBar(),
        );
      },
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onTap: () {
            context.push(AppRouteNames.myProfile.path);
          },
          child: Row(
            children: [
              AppAvatarWidget(
                avatarUrl: state.userBase?.avatar ?? "",
                size: 48,
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.userBase?.fullname ?? "",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(state.userBase?.email ?? ""),
                  ],
                ),
              ),
              PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      onTap: () {
                        context.read<AccountBloc>().logout();
                      },
                      child: Text(S.of(context).labelBtnLogout),
                    ),
                  ];
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
