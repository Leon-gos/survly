import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import 'package:survly/src/features/authentication/model/email_fomz_input.dart';
import 'package:survly/src/features/authentication/model/password_fomz_input.dart';

class LoginState extends Equatable {
  final EmailFormzInput email;
  final PasswordFormzInput password;
  final FormzSubmissionStatus status;
  final String message;
  final EmailFormzInput emailResetPassword;

  bool isValid() {
    return email.isValid && password.isValid;
  }

  bool emailResetPasswordValid() {
    return emailResetPassword.isValid;
  }

  const LoginState({
    required this.email,
    required this.password,
    required this.status,
    required this.message,
    required this.emailResetPassword,
  });

  factory LoginState.ds() => const LoginState(
        email: EmailFormzInput.pure(""),
        password: PasswordFormzInput.pure(""),
        status: FormzSubmissionStatus.initial,
        message: "",
        emailResetPassword: EmailFormzInput.pure(""),
      );

  @override
  List<Object?> get props => [
        email,
        password,
        status,
        emailResetPassword,
      ];

  LoginState copyWith({
    EmailFormzInput? email,
    PasswordFormzInput? password,
    FormzSubmissionStatus? status,
    String? message,
    EmailFormzInput? emailResetPassword,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      message: message ?? this.message,
      emailResetPassword: emailResetPassword ?? this.emailResetPassword,
    );
  }
}
