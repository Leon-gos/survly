import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/features/dashboard/logic/account_bloc.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/local/secure_storage/authentication/authentication_repository_impl.dart';
import 'package:survly/src/network/data/user/user_repository_impl.dart';
import 'package:survly/src/network/model/user_base/user_base.dart';
import 'package:survly/src/router/coordinator.dart';
import 'package:survly/src/router/router_name.dart';
import 'package:survly/src/theme/colors.dart';
import 'package:survly/widgets/app_app_bar.dart';
import 'package:survly/widgets/app_loading_circle.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<StatefulWidget> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    loadUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBarWidget(
        noActionBar: true,
        backgroundColor: AppColors.backgroundBrightness,
      ),
      body: const Center(
        child: AppLoadingCircle(),
      ),
    );
  }

  Future<void> loadUser() async {
    var userBase = UserBaseSingleton.instance().userBase;
    if (userBase != null) {
      if (userBase.role == UserBase.roleAdmin) {
        AppCoordinator.showSurveyManagementScreen();
        return;
      } else {
        AppCoordinator.goNamed(AppRouteNames.dashboardUser.path);
      }
    }

    var loginInfo = await AuthenticationRepositoryImpl().readLoginInfo();
    if (loginInfo != null && loginInfo.isNotEmpty) {
      try {
        await UserRepositoryImpl()
            .fetchUserByEmail(loginInfo.email)
            .then((value) {
          UserBaseSingleton.instance().userBase = value;
          context.read<AccountBloc>().onUserbaseChange(value);
          if (value?.role == UserBase.roleAdmin) {
            AppCoordinator.goNamed(AppRouteNames.survey.path);
          } else {
            AppCoordinator.goNamed(AppRouteNames.explore.path);
          }
          return;
        });
      } catch (e) {
        AppCoordinator.goNamed(AppRouteNames.login.path);
        Logger().d(e);
      }
    } else {
      AppCoordinator.goNamed(AppRouteNames.login.path);
    }
  }
}
