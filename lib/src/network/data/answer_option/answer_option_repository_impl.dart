import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:survly/src/config/constants/firebase_collections.dart';
import 'package:survly/src/network/data/answer_option/answer_option_repository.dart';
import 'package:survly/src/network/model/question_option/question_option.dart';

class AnswerOptionRepositoryImpl implements AnswerOptionRepository {
  final ref = FirebaseFirestore.instance
      .collection(AnswerOptionCollection.collectionName);

  @override
  Future<bool> isOptionChecked(
      {required String optionId, required String userId}) async {
    var value = await ref
        .where(AnswerOptionCollection.fieldOptionId, isEqualTo: optionId)
        .where(AnswerOptionCollection.fieldUserId, isEqualTo: userId)
        .get();
    return value.docs.isNotEmpty;
  }

  @override
  Future<void> answerOption(
      {required List<QuestionOption> optionList,
      required Set<String> optionIdCheckedList,
      required String userId}) async {
    for (var option in optionList) {
      var value = await ref
          .where(AnswerOptionCollection.fieldOptionId,
              isEqualTo: option.questionOptionId)
          .where(AnswerOptionCollection.fieldUserId, isEqualTo: userId)
          .get();
      if (value.docs.isNotEmpty) {
        ref.doc(value.docs[0].id).delete();
      }
    }
    for (var optionId in optionIdCheckedList) {
      ref.add({
        AnswerOptionCollection.fieldOptionId: optionId,
        AnswerOptionCollection.fieldUserId: userId,
      });
    }
  }
}
