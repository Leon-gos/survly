import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/config/constants/firebase_collections.dart';
import 'package:survly/src/network/data/option/option_repository_impl.dart';
import 'package:survly/src/network/data/question/question_repository.dart';
import 'package:survly/src/network/model/question/question.dart';
import 'package:survly/src/network/model/question/question_with_options.dart';
import 'package:survly/src/network/model/question_option/question_option.dart';

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
        if (question.questionType == QuestionType.singleOption.value ||
            question.questionType == QuestionType.multiOption.value) {
          final optionRepo = OptionRepositoryImpl();
          for (var option in (question as QuestionWithOption).optionList) {
            option.questionId = question.questionId;
            optionRepo.createOption(option);
          }
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteAllQuestionOfSurvey(String surveyId) async {
    final optionRepo = OptionRepositoryImpl();
    var value = await ref
        .where(QuestionCollection.fieldSurveyId, isEqualTo: surveyId)
        .get();
    Logger().d("num of ques: ${value.docs.length}");
    for (var doc in value.docs) {
      await optionRepo.deleteAllOptionOfQuestion(doc.id);
      await ref.doc(doc.id).delete();
    }
  }

  @override
  Future<List<Question>> fetchAllQuestionOfSurvey(String surveyId) async {
    List<Question> questionList = [];
    var value = await ref
        .where(QuestionCollection.fieldSurveyId, isEqualTo: surveyId)
        .orderBy(QuestionCollection.fieldQuestionIndex)
        .get();
    for (var doc in value.docs) {
      try {
        Question question;
        if (doc[QuestionCollection.fieldQuestionType] ==
            QuestionType.text.value) {
          question = Question.fromMap(doc.data());
        } else {
          List<QuestionOption> optionList =
              await OptionRepositoryImpl().fetchAllOptionOfQuestion(doc.id);
          question = QuestionWithOption.fromMap({
            ...doc.data(),
            QuestionCollection.fieldOptionList: optionList,
          });
        }
        questionList.add(question);
      } catch (e) {
        Logger().e(e);
      }
    }
    return questionList;
  }
}
