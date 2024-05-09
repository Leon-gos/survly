import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/config/constants/firebase_collections.dart';
import 'package:survly/src/config/constants/notification.dart';
import 'package:survly/src/network/data/notification/noti_do_survey/noti_do_survey_repository_impl.dart';
import 'package:survly/src/network/data/notification/noti_request/noti_request_repository_impl.dart';
import 'package:survly/src/network/data/notification/notification/notification_repository.dart';
import 'package:survly/src/network/model/notification/noti_do_survey.dart';
import 'package:survly/src/network/model/notification/noti_request.dart';
import 'package:survly/src/network/model/notification/notification.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final ref = FirebaseFirestore.instance.collection(
    NotificationCollection.collectionName,
  );

  @override
  Future<void> createNoti(Notification notification) async {
    try {
      var value = await ref.add({
        NotificationCollection.fieldFromUserId: notification.fromUserId,
      });
      notification.notiId = value.id;
      await ref.doc(value.id).set(notification.toMapNoti());
      if (notification.type == NotiType.userRequestSurvey.value ||
          notification.type == NotiType.adminResponseUserRequest.value) {
        NotiRequestRepositoryImpl()
            .createNotiRequest(notification as NotiRequest);
      } else if (notification.type == NotiType.userResponseSurvey.value ||
          notification.type == NotiType.adminResponseSurvey.value) {
        NotiDoSurveyRepositoryImpl()
            .createNotiDoSurvey(notification as NotiDoSurvey);
      }
    } catch (e) {
      Logger().e("create noti error", error: e);
      rethrow;
    }
  }

  @override
  Future<List<Notification>> fetchAllNotificationOfUser(String userId) async {
    var notiRequestRepo = NotiRequestRepositoryImpl();
    var notiDoSurveyRepo = NotiDoSurveyRepositoryImpl();
    List<Notification> notiList = [];

    var value = await ref
        .where(NotificationCollection.fieldToUserId, isEqualTo: userId)
        .orderBy(NotificationCollection.fieldDateCreate, descending: true)
        .get();

    for (var doc in value.docs) {
      try {
        var notiType = doc.data()[NotificationCollection.fieldType];
        if (notiType == NotiType.adminResponseUserRequest.value ||
            notiType == NotiType.userRequestSurvey.value) {
          var notiRequest =
              await notiRequestRepo.fetchNotiRequestByNotiId(doc.id);

          if (notiRequest != null) {
            notiList.add(notiRequest);
          }
        } else if (notiType == NotiType.adminResponseSurvey.value ||
            notiType == NotiType.userResponseSurvey.value) {
          var notiDoSurvey =
              await notiDoSurveyRepo.fetchNotiDoSurveyByNotiId(doc.id);

          if (notiDoSurvey != null) {
            notiList.add(notiDoSurvey);
          }
        }
      } catch (e) {
        Logger().e("get noti error", error: e);
      }
    }

    return notiList;
  }

  @override
  Future<void> readNoti(String notiId) async {
    try {
      await ref.doc(notiId).update({
        NotificationCollection.fieldIsRead: true,
      });
    } catch (e) {
      Logger().e("read noti error", error: e);
      rethrow;
    }
  }

  Future<Notification?> fetchNotificationById(String notiId) async {
    var value = await ref.doc(notiId).get();
    if (value.data() != null) {
      return Notification.fromMap(value.data()!);
    }
    return null;
  }
}
