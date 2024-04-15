import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:survly/src/features/dashboard_admin/logic/account_bloc.dart';
import 'package:survly/src/features/dashboard_admin/logic/bottom_nav_bloc.dart';
import 'package:survly/src/features/dashboard_admin/logic/navigation_bar_item.dart';
import 'package:survly/src/features/dashboard_admin/widget/bottom_navigation_bar.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/local/secure_storage/authentication/authentication_repository_impl.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/model/user_base/user_base.dart';
import 'package:survly/src/router/router_name.dart';
import 'package:survly/src/theme/colors.dart';
import 'package:survly/widgets/app_app_bar.dart';
import 'package:survly/widgets/app_avatar_widget.dart';

class DashboardAdminScreen extends StatelessWidget {
  final Widget body;
  final MyBottomNavBarItems currentItem;

  const DashboardAdminScreen(
      {super.key, required this.body, required this.currentItem});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BottomNavBloc(currentItem),
        ),
        BlocProvider(
          create: (context) =>
              AccountBloc(UserBaseSingleton.instance().userBase!),
        ),
      ],
      child: _buildDashboardScreen(context),
    );
  }

  Widget _buildDashboardScreen(BuildContext context) {
    return BlocBuilder<BottomNavBloc, MyBottomNavBarItems>(
      builder: (context, state) {
        return Scaffold(
          appBar: const AppAppBarWidget(
            noActionBar: true,
            backgroundColor: AppColors.white,
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
    return BlocBuilder<AccountBloc, UserBase>(builder: (context, state) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                AppAvatarWidget(
                  avatarUrl: state.avatar,
                  size: 48,
                ),
                const SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.fullname,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(state.email),
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
                          context.push(AppRouteNames.doSurvey.path);
                        },
                        child: const Text("Demo update location"),
                      ),
                      PopupMenuItem(
                        onTap: () {
                          context.push(AppRouteNames.doSurveyTracking.path);
                        },
                        child: const Text("Demo location track"),
                      ),
                      PopupMenuItem(
                        onTap: () {
                          AuthenticationRepositoryImpl().clearLoginInfo();
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
        ],
      );
    });
  }
}
