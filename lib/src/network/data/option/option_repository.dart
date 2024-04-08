import 'package:survly/src/network/model/question_option/question_option.dart';

abstract class OptionRepository {
  Future<void> createOption(QuestionOption questionOption);
}
