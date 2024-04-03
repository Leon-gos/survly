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

    await ref.get().then((value) {
      for (var doc in value.docs) {
        var data = doc.data();
        data[SurveyCollection.fieldSurveyId] = doc.id;
        list.add(Survey.fromMap(data));
      }
    });

    return list;
  }
}
