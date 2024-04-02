import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/src/network/model/admin.dart';

class AccountBloc extends Cubit<Admin> {
  AccountBloc(super.initialState);

  void onAdminChange(Admin admin) {
    emit(admin);
  }
}