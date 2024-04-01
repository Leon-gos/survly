import 'package:formz/formz.dart';
import 'package:survly/src/features/authentication/model/form_error.dart';
import 'package:survly/src/localization/localization_utils.dart';

class PasswordFormzInput extends FormzInput<String, FormError> {
  const PasswordFormzInput.pure([super.value = ""]) : super.pure();
  const PasswordFormzInput.dirty([super.value = ""]) : super.dirty();

  @override
  FormError? validator(String? value) {
    // Check if the password is empty
    if ((value ?? '').isEmpty) {
      return FormError.empty;
    }

    // Check minimum length of 6 characters
    if (value!.length < 6) {
      return FormError.passwordLength;
    }

    // Check for at least one lowercase letter (a-z)
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return FormError.passwordMissLowerChar;
    }

    // Check for at least one uppercase letter (A-Z)
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return FormError.passwordMissUpperChar;
    }

    // Check for at least one digit (0-9)
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return FormError.passwordMissDigit;
    }

    // Check for at least one special character (such as !, @, #, $, &, *, or ~)
    if (!RegExp(r'[!@#$&*~]').hasMatch(value)) {
      return FormError.passwordMissSpecialChar;
    }

    // If all conditions pass, return null (valid password)
    return null;
  }

  String? errorOf() {
    if (isPure) {
      return null;
    }
    switch (error) {
      case FormError.empty:
      case FormError.passwordLength:
        return S.text.errorPasswordLength;
      case FormError.passwordMissLowerChar:
        return S.text.errorPasswordMissLowerChar;
      case FormError.passwordMissUpperChar:
        return S.text.errorPasswordMissUpperChar;
      case FormError.passwordMissDigit:
        return S.text.errorPasswordMissDigit;
      case FormError.passwordMissSpecialChar:
        return S.text.errorPasswordMissSpecialChar;
      default:
        return null;
    }
  }
}
