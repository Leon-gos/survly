import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/config/constants/firebase_collections.dart';
import 'package:survly/src/network/data/notification/noti_do_survey/noti_do_survey_repository.dart';
import 'package:survly/src/network/data/notification/notification/notification_repository_impl.dart';
import 'package:survly/src/network/model/notification/noti_do_survey.dart';

class NotiDoSurveyRepositoryImpl implements NotiDoSurveyRepository {
  final ref = FirebaseFirestore.instance
      .collection(NotiDoSurveyCollection.collectionName);

  @override
  Future<void> createNotiDoSurvey(NotiDoSurvey notiDoSurvey) async {
    try {
      var value = await ref.add({
        NotiDoSurveyCollection.fieldNotiId: notiDoSurvey.notiId,
      });
      notiDoSurvey.doSurveyId = value.id;
      ref.doc(value.id).set(notiDoSurvey.toMap());
    } catch (e) {
      Logger().e("create noti request error", error: e);
      rethrow;
    }
  }

  @override
  Future<NotiDoSurvey?> fetchNotiDoSurveyById(String notiDoSurveyId) {
    // TODO: implement fetchNotiDoSurveyById
    throw UnimplementedError();
  }

  @override
  Future<NotiDoSurvey?> fetchNotiDoSurveyByNotiId(String notiId) async {
    try {
      var noti =
          await NotificationRepositoryImpl().fetchNotificationById(notiId);
      var valueNotiDoSurvey = await ref
          .where(NotiDoSurveyCollection.fieldNotiId, isEqualTo: notiId)
          .get();

      return NotiDoSurvey.fromMap({
        ...noti!.toMap(),
        ...valueNotiDoSurvey.docs[0].data(),
      });
    } catch (e) {
      Logger().e("fetch noti do survey error", error: e);
      rethrow;
    }
  }
}
