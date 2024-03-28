import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/src/features/authentication/bloc/sign_up_state.dart';

class SignUpBloc extends Cubit<SignUpState> {
  SignUpBloc() : super(SignUpState.ds());

  void signUp() {}

  void onEmailChange(String email) {
    emit(state.copyWith(email: email));
  }

  void onUserNameChange(String username) {
    emit(state.copyWith(username: username));
  }

  void onNameChange(String name) {
    emit(state.copyWith(name: name));
  }

  void onPasswordChange(String password) {
    emit(state.copyWith(password: password));
  }
}
