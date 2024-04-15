// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:survly/src/domain_manager.dart';
// import 'package:survly/src/features/dashboard_admin/logic/dashboard_admin_state.dart';

// class DashboardAdminBloc extends Cubit<DashboardAdminState> {
//   DashboardAdminBloc() : super(DashboardAdminState.ds()) {
//     fetchAdminInfo();
//   }

//   DomainManager get domain => DomainManager();

//   Future<void> fetchAdminInfo() async {
//     // var admin = UserBaseSingleton.instance().userBase;
//     // if (admin != null) {
//     //   emit(state.copyWith(status: DashboardStatus.done));
//     //   return;
//     // }

//     // var loginInfo = await domain.authenticationLocal.readLoginInfo();

//     // try {
//     //   await domain.user.fetchUserByEmail(loginInfo!.email).then((value) {
//     //     UserBaseSingleton.instance().userBase = value as Admin;
//     //     emit(state.copyWith(status: DashboardStatus.done));
//     //   });
//     // } catch (e) {
//     //   Logger().d(e);
//     //   AppCoordinator.showLoginScreen();
//     // }
//   }
// }
