import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import 'package:survly/src/features/authentication/model/email_fomz_input.dart';
import 'package:survly/src/features/authentication/model/name_fomz_input.dart';
import 'package:survly/src/features/authentication/model/password_fomz_input.dart';

class SignUpState extends Equatable {
  final EmailFormzInput email;
  final PasswordFormzInput password;
  final NameFormzInput name;
  final FormzSubmissionStatus status;
  final String message;

  const SignUpState({
    required this.email,
    required this.password,
    required this.name,
    required this.status,
    required this.message,
  });

  factory SignUpState.ds() => const SignUpState(
        email: EmailFormzInput.pure(""),
        password: PasswordFormzInput.pure(""),
        name: NameFormzInput.pure(""),
        status: FormzSubmissionStatus.initial,
        message: "",
      );

  bool isValid() {
    return email.isValid && password.isValid && name.isValid;
  }

  @override
  List<Object?> get props => [email, password, name, status];

  SignUpState copyWith({
    EmailFormzInput? email,
    PasswordFormzInput? password,
    NameFormzInput? name,
    FormzSubmissionStatus? status,
    String? message,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
