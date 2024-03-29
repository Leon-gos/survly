import 'package:formz/formz.dart';
import 'package:survly/src/features/authentication/model/form_error.dart';

class EmailFormzInput extends FormzInput<String, FormError> {
  const EmailFormzInput.pure([super.value = ""]) : super.pure();
  const EmailFormzInput.dirty([super.value = ""]) : super.dirty();

  static final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  @override
  FormError? validator(String? value) {
    if ((value ?? '').isEmpty) {
      return FormError.empty;
    }
    return emailRegExp.hasMatch(value ?? '') ? null : FormError.invalid;
  }
}
