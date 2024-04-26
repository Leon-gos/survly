import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/config/constants/firebase_collections.dart';
import 'package:survly/src/network/data/survey_request/survey_request_repository.dart';
import 'package:survly/src/network/data/user/user_repository_impl.dart';
import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/src/network/model/survey_request/survey_request.dart';

class SurveyRequestRepositoryImpl implements SurveyRequestRepository {
  final ref = FirebaseFirestore.instance
      .collection(SurveyRequestCollection.collectionName);

  @override
  Future<List<SurveyRequest>> fetchAllSurveyRequest() async {
    List<SurveyRequest> list = [];
    var value = await ref.get();
    for (var doc in value.docs) {
      var request = SurveyRequest.fromMap(doc.data());
      request.requestId = doc.id;
      request.user = await UserRepositoryImpl().fetchUserById(request.userId);
      list.add(request);
    }
    return list;
  }

  @override
  Future<List<SurveyRequest>> fetchRequestOfSurvey(String surveyId) async {
    List<SurveyRequest> list = [];
    var value = await ref
        .where(SurveyRequestCollection.fieldSurveyId, isEqualTo: surveyId)
        .get();
    for (var doc in value.docs) {
      var request = SurveyRequest.fromMap(doc.data());
      request.requestId = doc.id;
      request.user = await UserRepositoryImpl().fetchUserById(request.userId);
      list.add(request);
    }
    return list;
  }

  @override
  Future<void> responseSurveyRequest({
    required String requestId,
    required SurveyRequestStatus status,
  }) async {
    try {
      await ref.doc(requestId).update({
        SurveyRequestCollection.fieldStatus: status.value,
      });
    } catch (e) {
      Logger().e("Change status survey request error", error: e);
      rethrow;
    }
  }

  @override
  Future<void> requestSurvey(Survey survey, SurveyRequest request) async {
    try {
      var numOfRequest = await numRequestOfSurvey(request.surveyId);
      if (numOfRequest < survey.respondentMax) {
        var value = await ref.add({});
        request.requestId = value.id;
        await ref.doc(value.id).set(request.toMap());
      } else {
        throw (Exception("Full of request"));
      }
    } catch (e) {
      Logger().e("request survey error", error: e);
      rethrow;
    }
  }

  @override
  Future<int> numRequestOfSurvey(String surveyId) async {
    int count = 0;
    var value = await ref
        .where(SurveyRequestCollection.fieldSurveyId, isEqualTo: surveyId)
        .get();
    for (var doc in value.docs) {
      if (doc[SurveyRequestCollection.fieldStatus] !=
          SurveyRequestStatus.denied.value) {
        count++;
      }
    }
    return count;
  }

  @override
  Future<void> cancelRequestSurvey(SurveyRequest request) async {
    try {
      await ref.doc(request.requestId).delete();
    } catch (e) {
      Logger().e("cancel survey error", error: e);
      rethrow;
    }
  }

  @override
  Future<SurveyRequest?> fetchLatestRequest({
    required String surveyId,
    required String userId,
  }) async {
    var value = await ref
        .where(SurveyRequestCollection.fieldSurveyId, isEqualTo: surveyId)
        .where(SurveyRequestCollection.fieldUserId, isEqualTo: userId)
        .get();
    Logger().d(value.docs.length);
    for (var doc in value.docs) {
      if (doc.data()[SurveyRequestCollection.fieldStatus] ==
              SurveyRequestStatus.pending.value ||
          doc.data()[SurveyRequestCollection.fieldStatus] ==
              SurveyRequestStatus.accepted.value) {
        return SurveyRequest.fromMap(doc.data());
      }
    }
    return null;
  }
}
