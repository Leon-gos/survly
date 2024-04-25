import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/authentication/logic/sign_up_state.dart';
import 'package:survly/src/features/authentication/model/email_fomz_input.dart';
import 'package:survly/src/features/authentication/model/name_fomz_input.dart';
import 'package:survly/src/features/authentication/model/password_confirm_fomz_input.dart';
import 'package:survly/src/features/authentication/model/password_fomz_input.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/router/coordinator.dart';

class SignUpBloc extends Cubit<SignUpState> {
  SignUpBloc() : super(SignUpState.ds());

  DomainManager get domain => DomainManager();

  Future<void> signUpByEmailPassword() async {
    emit(state.copyWith(isLoading: true));
    emit(state.copyWith(email: EmailFormzInput.dirty(state.email.value)));
    emit(state.copyWith(name: NameFormzInput.dirty(state.name.value)));
    emit(state.copyWith(
        password: PasswordFormzInput.dirty(state.password.value)));
    emit(
      state.copyWith(
        passwordConfirm: PasswordConfirmFormzInput.dirty(
            state.password.value, state.passwordConfirm.value),
      ),
    );
    if (!state.isValid()) {
      emit(state.copyWith(isLoading: false));
      return;
    }

    try {
      await domain.authentication.signUpEmailPassword(
        state.email.value,
        state.password.value,
        state.name.value,
      );
      Fluttertoast.showToast(msg: "Sign up successfully");
      AppCoordinator.pop();
    } catch (e) {
      Fluttertoast.showToast(msg: S.text.errorGeneral);
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  void onEmailChange(String email) {
    emit(state.copyWith(email: EmailFormzInput.pure(email)));
  }

  void onNameChange(String name) {
    emit(state.copyWith(name: NameFormzInput.pure(name)));
  }

  void onPasswordChange(String password) {
    emit(state.copyWith(password: PasswordFormzInput.pure(password)));
  }

  void onPasswordConfirmChange(String passwordConfirm) {
    emit(
      state.copyWith(
        passwordConfirm: PasswordConfirmFormzInput.pure(
          state.password.value,
          passwordConfirm,
        ),
      ),
    );
  }
}
