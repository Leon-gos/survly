import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:survly/src/config/constants/firebase_collections.dart';
import 'package:survly/src/network/data/survey/survey_repository.dart';
import 'package:survly/src/network/model/survey/survey.dart';

class SurveyRepositoryImpl implements SurveyRepository {
  final ref =
      FirebaseFirestore.instance.collection(SurveyCollection.collectionName);

  static const int pageSize = 8;

  @override
  Future<List<Survey>> fetchFirstPageSurvey() async {
    List<Survey> list = [];

    var value =
        await ref.orderBy(SurveyCollection.fieldTitle).limit(pageSize).get();
    for (var doc in value.docs) {
      var data = doc.data();
      data[SurveyCollection.fieldSurveyId] = doc.id;
      list.add(Survey.fromMap(data));
    }

    return list;
  }

  @override
  Future<List<Survey>> fetchMoreSurvey({required Survey lastSurvey}) async {
    List<Survey> list = [];

    var lastDoc = await ref.doc(lastSurvey.surveyId).get();
    var value = await ref
        .orderBy(SurveyCollection.fieldTitle)
        .startAfterDocument(lastDoc)
        .limit(pageSize)
        .get();
    for (var doc in value.docs) {
      var data = doc.data();
      data[SurveyCollection.fieldSurveyId] = doc.id;
      list.add(Survey.fromMap(data));
    }

    return list;
  }

  @override
  Future<void> createSurvey(Survey survey) async {
    // TODO: not yet done
    // test only
    ref.add({}).then((value) {
      // var survey = Survey(
      //   surveyId: value.id,
      //   dateCreate: "",
      //   dateUpdate: "",
      //   status: "",
      //   adminId: AdminSingleton.instance().admin?.id ?? "",
      // );
      survey.surveyId = value.id;
      ref.doc("/${value.id}").set(survey.toMap());
    });
  }
}
