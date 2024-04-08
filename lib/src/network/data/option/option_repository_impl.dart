import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:survly/src/config/constants/firebase_collections.dart';
import 'package:survly/src/network/data/option/option_repository.dart';
import 'package:survly/src/network/model/question_option/question_option.dart';

class OptionRepositoryImpl implements OptionRepository {
  final ref = FirebaseFirestore.instance.collection(
    OptionCollection.collectionName,
  );

  @override
  Future<void> createOption(QuestionOption questionOption) async {
    try {
      final value = await ref.add({});
      questionOption.questionOptionId = value.id;
      ref.doc(value.id).set(questionOption.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAllOptionOfQuestion(String questionId) async {
    var value = await ref
        .where(OptionCollection.fieldQuestionId, isEqualTo: questionId)
        .get();
    for (var doc in value.docs) {
      ref.doc(doc.id).delete();
    }
  }
}
