import 'dart:ffi';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/authentication/logic/login_state.dart';
import 'package:survly/src/features/authentication/model/email_fomz_input.dart';
import 'package:survly/src/features/authentication/model/password_fomz_input.dart';

class LoginBloc extends Cubit<LoginState> {
  LoginBloc() : super(LoginState.ds());

  DomainManager get domain => DomainManager();

  Future<void> loginWithEmailPassword() async {
    try {
      await domain.authentication.loginWithEmailPassword(
        state.email.value,
        state.password.value,
      );
      var admin = await domain.admin.getAdminByEmail(state.email.value);
      print(admin?.fullname);
    } catch (e) {
      print(e);
    }
  }

  void loginWithGoogle() {
    domain.authentication.loginWithGoogle();
  }

  void onEmailChange(String email) {
    emit(state.copyWith(email: EmailFormzInput.pure(email)));
  }

  void onPasswordChange(String password) {
    emit(state.copyWith(password: PasswordFormzInput.pure(password)));
  }
}
