import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:survly/src/features/authentication/logic/sign_up_bloc.dart';
import 'package:survly/src/features/authentication/logic/sign_up_state.dart';

void main() {
  group("Sign up test", () {
    blocTest<SignUpBloc, SignUpState>(
      "Test sign up with email pass",
      build: () => SignUpBloc(),
      act: (bloc) {
        bloc.onEmailChange("abc@gmail.com");
      },
      expect: () {
        return [];
      },
    );
  });
}
