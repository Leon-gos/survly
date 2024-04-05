import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:survly/src/config/constants/firebase_collections.dart';
import 'package:survly/src/network/data/question/question_repository.dart';
import 'package:survly/src/network/model/question/question.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  final ref = FirebaseFirestore.instance.collection(
    QuestionCollection.collectionName,
  );

  @override
  Future<void> createQuestion(Question question) async {
    try {
      await ref.add({}).then((value) {
        question.questionId = value.id;
        ref.doc("/${value.id}").set(question.toMap());
      });
    } catch (e) {
      rethrow;
    }
  }
}
