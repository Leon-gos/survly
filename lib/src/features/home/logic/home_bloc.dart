import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/home/logic/home_state.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/router/coordinator.dart';

class HomeBloc extends Cubit<HomeState> {
  HomeBloc() : super(HomeState.ds());

  DomainManager get domain => DomainManager();

  Future<void> fetchAdminInfo() async {
    var admin = AdminSingleton.instance().admin;
    if (admin != null) {
      emit(state.copyWith(status: HomeStatus.done));
      return;
    }

    var loginInfo = await domain.authenticationLocal.readLoginInfo();

    try {
      await domain.admin.getAdminByEmail(loginInfo!.email).then((value) {
        AdminSingleton.instance().admin = value;
        emit(state.copyWith(status: HomeStatus.done));
      });
    } catch (e) {
      print(e);
      AppCoordinator.showLoginScreen();
    }
  }
}
