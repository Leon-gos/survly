import 'package:survly/src/network/model/question_option/question_option.dart';

abstract class AnswerOptionRepository {
  Future<bool> isOptionChecked({
    required String optionId,
    required String userId,
  });

  Future<void> answerOption({
    required List<QuestionOption> optionList,
    required Set<String> optionIdCheckedList,
    required String userId,
  });
}
