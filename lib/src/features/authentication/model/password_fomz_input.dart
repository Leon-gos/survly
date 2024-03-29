import 'package:formz/formz.dart';
import 'package:survly/src/features/authentication/model/form_error.dart';

class PasswordFormzInput extends FormzInput<String, FormError> {
  const PasswordFormzInput.pure([super.value = ""]) : super.pure();
  const PasswordFormzInput.dirty([super.value = ""]) : super.dirty();

  static final RegExp regExp = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$&*~]).{6,}$',
  );

  @override
  FormError? validator(String? value) {
    if ((value ?? '').isEmpty) {
      return FormError.empty;
    }
    return regExp.hasMatch(value ?? '') ? null : FormError.invalid;
  }
}
