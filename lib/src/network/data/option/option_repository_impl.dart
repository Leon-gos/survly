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
}
