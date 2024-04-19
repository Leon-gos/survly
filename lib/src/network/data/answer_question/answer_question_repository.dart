abstract class AnswerQuestionRepository {
  Future<String?> fetchQuestionAnswer({
    required String questionId,
    required String userId,
  });

  Future<void> answerQuestion({
    required String questionId,
    required String userId,
    required String answer,
  });
}
