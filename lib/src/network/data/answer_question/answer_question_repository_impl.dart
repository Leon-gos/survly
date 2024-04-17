import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:survly/src/config/constants/firebase_collections.dart';
import 'package:survly/src/network/data/answer_question/answer_question_repository.dart';

class AnswerQuestionRepositoryImpl implements AnswerQuestionRepository {
  final ref = FirebaseFirestore.instance
      .collection(AnswerQuestionCollection.collectionName);

  @override
  Future<String?> fetchQuestionAnswer({
    required String questionId,
    required String userId,
  }) async {
    var value = await ref
        .where(AnswerQuestionCollection.fieldQuestionId, isEqualTo: questionId)
        .where(AnswerOptionCollection.fieldUserId, isEqualTo: userId)
        .get();
    if (value.docs.isNotEmpty) {
      return value.docs[0].data()[AnswerQuestionCollection.fieldAnswer];
    }
    return null;
  }

  @override
  Future<void> answerQuestion({
    required String questionId,
    required String userId,
    required String answer,
  }) async {
    var value = await ref
        .where(AnswerQuestionCollection.fieldQuestionId, isEqualTo: questionId)
        .where(AnswerOptionCollection.fieldUserId, isEqualTo: userId)
        .get();

    if (value.docs.isNotEmpty) {
      await ref.doc(value.docs[0].id).update(
        {AnswerQuestionCollection.fieldAnswer: answer},
      );
    } else {
      await ref.add({
        AnswerQuestionCollection.fieldQuestionId: questionId,
        AnswerQuestionCollection.fieldUserId: userId,
        AnswerQuestionCollection.fieldAnswer: answer,
      });
    }
  }
}
