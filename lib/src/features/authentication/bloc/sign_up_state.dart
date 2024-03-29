import 'package:equatable/equatable.dart';

class SignUpState extends Equatable {
  final String email;
  final String username;
  final String name;
  final String password;
  final String confirmPassword;

  const SignUpState({
    required this.email,
    required this.username,
    required this.name,
    required this.password,
    required this.confirmPassword,
  });

  factory SignUpState.ds() => const SignUpState(
        email: "",
        username: "",
        name: "",
        password: "",
        confirmPassword: "",
      );

  @override
  List<Object?> get props => [email, username, name, password, confirmPassword];

  SignUpState copyWith({
    String? email,
    String? username,
    String? name,
    String? password,
    String? confirmPassword,
  }) {
    return SignUpState(
      email: email ?? this.email,
      username: username ?? this.username,
      name: name ?? this.name,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }
}
