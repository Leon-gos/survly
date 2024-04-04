import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/dashboard/logic/dashboard_state.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/router/coordinator.dart';

class DashboardBloc extends Cubit<DashboardState> {
  DashboardBloc() : super(DashboardState.ds()) {
    fetchAdminInfo();
  }

  DomainManager get domain => DomainManager();

  Future<void> fetchAdminInfo() async {
    var admin = AdminSingleton.instance().admin;
    if (admin != null) {
      emit(state.copyWith(status: DashboardStatus.done));
      return;
    }

    var loginInfo = await domain.authenticationLocal.readLoginInfo();

    try {
      await domain.admin.getAdminByEmail(loginInfo!.email).then((value) {
        AdminSingleton.instance().admin = value;
        emit(state.copyWith(status: DashboardStatus.done));
      });
    } catch (e) {
      Logger().d(e);
      AppCoordinator.showLoginScreen();
    }
  }
}
