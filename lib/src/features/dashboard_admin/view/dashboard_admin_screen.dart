import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:survly/src/features/dashboard/logic/account_bloc.dart';
import 'package:survly/src/features/dashboard/logic/account_state.dart';
import 'package:survly/src/features/dashboard_admin/logic/bottom_nav_bloc.dart';
import 'package:survly/src/features/dashboard_admin/logic/navigation_bar_item.dart';
import 'package:survly/src/features/dashboard_admin/widget/bottom_navigation_bar.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/local/secure_storage/authentication/authentication_repository_impl.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/router/router_name.dart';
import 'package:survly/src/theme/colors.dart';
import 'package:survly/widgets/app_app_bar.dart';
import 'package:survly/widgets/app_avatar_widget.dart';

class DashboardAdminScreen extends StatelessWidget {
  final Widget body;
  final AdminBottomNavBarItems currentItem;

  const DashboardAdminScreen(
      {super.key, required this.body, required this.currentItem});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavBloc(currentItem),
      child: _buildDashboardScreen(context),
    );
  }

  Widget _buildDashboardScreen(BuildContext context) {
    return BlocBuilder<BottomNavBloc, AdminBottomNavBarItems>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppAppBarWidget(
            noActionBar: true,
            backgroundColor: AppColors.backgroundBrightness,
          ),
          body: Column(
            children: [
              _buildAdminInfo(context),
              Expanded(child: body),
            ],
          ),
          bottomNavigationBar: const MyBottomNavBar(),
        );
      },
    );
  }

  Widget _buildAdminInfo(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(builder: (context, state) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () {
                context.push(AppRouteNames.adminProfile.path);
              },
              child: Row(
                children: [
                  AppAvatarWidget(
                    avatarUrl: state.userBase.avatar,
                    size: 48,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.userBase.fullname,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(state.userBase.email),
                    ],
                  ),
                  const Spacer(),
                  PopupMenuButton(
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          onTap: () {
                            context.push(AppRouteNames.createSurvey.path);
                          },
                          child: Text(S.of(context).titleCreateSurvey),
                        ),
                        PopupMenuItem(
                          onTap: () {
                            AuthenticationRepositoryImpl().clearLoginInfo();
                            UserBaseSingleton.instance().userBase = null;
                            context.goNamed(AppRouteNames.login.path);
                          },
                          child: Text(S.of(context).labelBtnLogout),
                        ),
                      ];
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}