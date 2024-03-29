import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/authentication/logic/login_state.dart';
import 'package:survly/src/features/authentication/model/email_fomz_input.dart';
import 'package:survly/src/features/authentication/model/password_fomz_input.dart';

class LoginBloc extends Cubit<LoginState> {
  LoginBloc() : super(LoginState.ds());

  DomainManager get domain => DomainManager();

  void loginWithEmailPassword() {
    domain.authentication.loginWithEmailPassword(
      state.email.value,
      state.password.value,
    );
  }

  void onEmailChange(String email) {
    emit(state.copyWith(email: EmailFormzInput.pure(email)));
  }

  void onPasswordChange(String password) {
    emit(state.copyWith(password: PasswordFormzInput.pure(password)));
  }
}
