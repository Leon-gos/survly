import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/authentication/logic/login_state.dart';
import 'package:survly/src/features/authentication/model/email_fomz_input.dart';
import 'package:survly/src/features/authentication/model/password_fomz_input.dart';
import 'package:survly/src/local/model/login_info.dart';
import 'package:survly/src/router/coordinator.dart';

class LoginBloc extends Cubit<LoginState> {
  LoginBloc() : super(LoginState.ds());

  DomainManager get domain => DomainManager();

  void loginWithEmailPassword() async {
    emit(state.copyWith(email: EmailFormzInput.dirty(state.email.value)));
    emit(state.copyWith(
        password: PasswordFormzInput.dirty(state.password.value)));
    if (!state.isValid()) {
      return;
    }
    try {
      await domain.authentication.loginWithEmailPassword(
        state.email.value,
        state.password.value,
      );
      domain.authenticationLocal
          .storeLoginInfo(
        LoginInfo(
          email: state.email.value,
          password: state.password.value,
        ),
      )
          .then((value) {
        AppCoordinator.showSurveyManagementScreen();
      });
    } catch (e) {
      Logger().d(e);
    }
  }

  Future<void> loginWithGoogle() async {
    var user = await domain.authentication.loginWithGoogle();
    if (user?.user?.email != "") {
      // sign in successful
      domain.authenticationLocal
          .storeLoginInfo(
        LoginInfo(
          email: user!.user!.email!,
          password: "",
        ),
      )
          .then((value) {
        AppCoordinator.showSurveyManagementScreen();
      });
    }
  }

  void onEmailChange(String email) {
    emit(state.copyWith(email: EmailFormzInput.pure(email)));
  }

  void onPasswordChange(String password) {
    emit(state.copyWith(password: PasswordFormzInput.pure(password)));
  }
}
