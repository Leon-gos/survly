import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/authentication/logic/login_state.dart';
import 'package:survly/src/features/authentication/model/email_fomz_input.dart';
import 'package:survly/src/features/authentication/model/password_fomz_input.dart';
import 'package:survly/src/local/model/login_info.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/router/coordinator.dart';
import 'package:survly/src/router/router_name.dart';

class LoginBloc extends Cubit<LoginState> {
  LoginBloc() : super(LoginState.ds());

  DomainManager get domain => DomainManager();

  void loginWithEmailPassword() async {
    emit(state.copyWith(isLoading: true));
    emit(state.copyWith(email: EmailFormzInput.dirty(state.email.value)));
    emit(state.copyWith(
        password: PasswordFormzInput.dirty(state.password.value)));
    if (!state.isValid()) {
      emit(state.copyWith(isLoading: false));
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
        AppCoordinator.goNamed(AppRouteNames.dashboard.path);
      });
    } catch (e) {
      Logger().e(e);
      Fluttertoast.showToast(msg: S.text.errorEmailPasswordIncorrect);
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> loginWithGoogle() async {
    emit(state.copyWith(isLoading: true));
    try {
      var user = await domain.authentication.loginWithGoogle();
      if (user?.user?.email != null && user?.user?.email != "") {
        // sign in successful
        domain.authenticationLocal
            .storeLoginInfo(
          LoginInfo(
            email: user!.user!.email!,
            password: "",
          ),
        )
            .then((value) {
          emit(state.copyWith(isLoading: false));
          AppCoordinator.goNamed(AppRouteNames.dashboard.path);
        });
      } else {
        Fluttertoast.showToast(msg: S.text.errorGeneral);
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      Logger().e("Login with google error", error: e);
      Fluttertoast.showToast(msg: S.text.errorGeneral);
      emit(state.copyWith(isLoading: false));
    }
  }

  void onEmailChange(String email) {
    emit(state.copyWith(email: EmailFormzInput.pure(email)));
  }

  void onPasswordChange(String password) {
    emit(state.copyWith(password: PasswordFormzInput.pure(password)));
  }
}
