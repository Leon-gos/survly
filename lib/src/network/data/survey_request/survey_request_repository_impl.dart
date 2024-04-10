import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:survly/src/config/constants/firebase_collections.dart';
import 'package:survly/src/network/data/survey_request/survey_request_repository.dart';
import 'package:survly/src/network/model/survey_request/survey_request.dart';

class SurveyRequestRepositoryImpl implements SurveyRequestRepository {
  final ref = FirebaseFirestore.instance
      .collection(SurveyRequestCollection.collectionName);

  @override
  Future<List<SurveyRequest>> fetchSurveyRequest(String surveyId) async {
    List<SurveyRequest> list = [];
    var value = await ref.get();
    for (var doc in value.docs) {
      var request = SurveyRequest.fromMap(doc.data());
      // request.user =
      list.add(request);
    }
    return list;
  }
}
