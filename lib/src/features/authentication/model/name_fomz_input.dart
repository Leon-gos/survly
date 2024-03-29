import 'package:formz/formz.dart';
import 'package:survly/src/features/authentication/model/form_error.dart';
import 'package:survly/src/localization/temp_localization.dart';

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

  String? errorOf() {
    if (isPure) {
      return null;
    }
    switch (error) {
      case FormError.empty:
        return TempLocalization.errorEmptyName;
      default:
        return null;
    }
  }
  
}