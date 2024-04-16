import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/src/features/dashboard_user/logic/navigation_bar_item.dart';
import 'package:survly/src/router/coordinator.dart';

class BottomNavBloc extends Cubit<UserBottomNavBarItems> {
  BottomNavBloc(super.current);

  void onDestinationSelected(int index) {
    emit(UserBottomNavBarItems.values[index]);
    AppCoordinator.goNamed(state.route.name);
  }

  void goHome() {
    emit(UserBottomNavBarItems.explore);
    AppCoordinator.goNamed(state.route.name);
  }
}
