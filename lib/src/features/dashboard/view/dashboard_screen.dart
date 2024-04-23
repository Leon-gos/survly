import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/config/constants/notification.dart';
import 'package:survly/src/features/dashboard/logic/account_bloc.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/local/secure_storage/authentication/authentication_repository_impl.dart';
import 'package:survly/src/network/data/user/user_repository_impl.dart';
import 'package:survly/src/network/model/user_base/user_base.dart';
import 'package:survly/src/router/coordinator.dart';
import 'package:survly/src/router/router_name.dart';
import 'package:survly/src/service/notification_service.dart';
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
    setupInteractedMessage();
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    Fluttertoast.showToast(msg: "Handle push noti");
    String? type = message.data[NotiDataField.type];
    String? data = message.data[NotiDataField.data];

    if (type == NotiType.adminResponseSurvey.value) {
      AppCoordinator.context.push(AppRouteNames.myProfile.path);
    } else if (type == NotiType.userResponseSurvey.value) {
      if (data != null) {
        var extra = jsonDecode(data);
        extra = List<String>.from(extra);
        AppCoordinator.context.push(
          AppRouteNames.responseUserSurvey.path,
          extra: extra,
        );
      }
    }
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
        NotificationService.registerToken();
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
            .then((value) async {
          UserBaseSingleton.instance().userBase = value;
          NotificationService.registerToken();
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
