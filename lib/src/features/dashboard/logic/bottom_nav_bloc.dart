import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/src/features/dashboard/logic/navigation_bar_item.dart';
import 'package:survly/src/router/coordinator.dart';

class BottomNavBloc extends Cubit<MyBottomNavBarItems> {
  BottomNavBloc(super.current);

  void onDestinationSelected(int index) {
    emit(MyBottomNavBarItems.values[index]);
    AppCoordinator.goNamed(state.route.name);
  }

  void goHome() {
    emit(MyBottomNavBarItems.survey);
    AppCoordinator.goNamed(state.route.name);
  }
}
