import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/src/features/home/logic/home_state.dart';

class HomeBloc extends Cubit<HomeState> {
  HomeBloc() : super(HomeState.ds());

  Future<void> fetchAdminInfo() async {
    await Future.delayed(const Duration(seconds: 2));
    emit(state.copyWith(status: HomeStatus.done));
  }
}