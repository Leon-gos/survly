import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:survly/src/config/constants/firebase_collections.dart';
import 'package:survly/src/network/data/survey/survey_repository.dart';
import 'package:survly/src/network/model/survey/survey.dart';

class SurveyRepositoryImpl implements SurveyRepository {
  final ref =
      FirebaseFirestore.instance.collection(SurveyCollection.collectionName);

  @override
  Future<List<Survey>> fetchAllSurvey() async {
    List<Survey> list = [];

    final value = await ref.get();
    for (var doc in value.docs) {
      var data = doc.data();
      data[SurveyCollection.fieldSurveyId] = doc.id;
      list.add(Survey.fromMap(data));
    }

    return list;
  }

  @override
  Future<void> createSurvey() async {
    // TODO: not yet done
    // test only
    ref.add({}).then((value) {
      var survey = Survey(
        surveyId: value.id,
        dateCreate: "",
        dateUpdate: "",
        status: "",
        adminId: "",
      );
      ref.doc("/${value.id}").set(survey.toMap());
    });
  }
}
