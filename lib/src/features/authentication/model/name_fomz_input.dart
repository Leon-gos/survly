import 'package:formz/formz.dart';
import 'package:survly/src/features/authentication/model/form_error.dart';

class NameFormzInput extends FormzInput<String, FormError> {
  const NameFormzInput.pure(super.value) : super.pure();
  const NameFormzInput.dirty(super.value) : super.dirty();

  @override
  FormError? validator(String? value) {
    if ((value ?? '').isEmpty) {
      return FormError.empty;
    }
    return null;
  }
  
}