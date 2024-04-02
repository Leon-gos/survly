import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/src/network/model/user_base/user_base.dart';

class AccountBloc extends Cubit<UserBase> {
  AccountBloc(super.initialState);

  void onAdminChange(UserBase userBase) {
    emit(userBase);
  }
}