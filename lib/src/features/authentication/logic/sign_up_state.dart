import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import 'package:survly/src/features/authentication/model/email_fomz_input.dart';
import 'package:survly/src/features/authentication/model/name_fomz_input.dart';
import 'package:survly/src/features/authentication/model/password_confirm_fomz_input.dart';
import 'package:survly/src/features/authentication/model/password_fomz_input.dart';

class SignUpState extends Equatable {
  final EmailFormzInput email;
  final PasswordFormzInput password;
  final PasswordConfirmFormzInput passwordConfirm;
  final NameFormzInput name;
  final FormzSubmissionStatus status;
  final String message;
  final bool isLoading;

  const SignUpState({
    required this.email,
    required this.password,
    required this.passwordConfirm,
    required this.name,
    required this.status,
    required this.message,
    required this.isLoading,
  });

  factory SignUpState.ds() => const SignUpState(
        email: EmailFormzInput.pure(""),
        password: PasswordFormzInput.pure(""),
        passwordConfirm: PasswordConfirmFormzInput.pure("", ""),
        name: NameFormzInput.pure(""),
        status: FormzSubmissionStatus.initial,
        message: "",
        isLoading: false,
      );

  bool isValid() {
    return email.isValid &&
        password.isValid &&
        passwordConfirm.isValid &&
        name.isValid;
  }

  @override
  List<Object?> get props => [
        email,
        password,
        passwordConfirm,
        name,
        status,
        isLoading,
      ];

  SignUpState copyWith({
    EmailFormzInput? email,
    PasswordFormzInput? password,
    PasswordConfirmFormzInput? passwordConfirm,
    NameFormzInput? name,
    FormzSubmissionStatus? status,
    String? message,
    bool? isLoading,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirm: passwordConfirm ?? this.passwordConfirm,
      name: name ?? this.name,
      status: status ?? this.status,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
