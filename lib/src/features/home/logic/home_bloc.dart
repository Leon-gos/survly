import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/home/logic/home_state.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/router/router_name.dart';

class HomeBloc extends Cubit<HomeState> {
  HomeBloc() : super(HomeState.ds());

  DomainManager get domain => DomainManager();

  Future<void> fetchAdminInfo(BuildContext context) async {
    // await Future.delayed(const Duration(seconds: 2));

    var loginInfo = await domain.authenticationLocal.readLoginInfo();
    await domain.admin.getAdminByEmail(loginInfo!.email).then((value) {
      if (value != null) {
        AdminSingleton.instance().admin = value;
        print(
            "Admin singleton: ${AdminSingleton.instance().admin != null ? "true" : "false"}");
        emit(state.copyWith(status: HomeStatus.done));
      } else {
        context.replace(AppRouteNames.login.path);
      }
    });
  }
}
