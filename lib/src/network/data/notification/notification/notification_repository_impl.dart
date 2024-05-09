import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/config/constants/firebase_collections.dart';
import 'package:survly/src/config/constants/notification.dart';
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
      var value = await ref.add({});
      notification.notiId = value.id;
      await ref.doc(value.id).set(notification.toMap());
      if (notification.type == NotiType.userRequestSurvey.value ||
          notification.type == NotiType.adminResponseUserRequest.value) {
        // TODO: create noti request
      } else if (notification.type == NotiType.userResponseSurvey.value ||
          notification.type == NotiType.adminResponseSurvey.value) {
        // TODO: create noti do survey
      }
    } catch (e) {
      Logger().e("create noti error", error: e);
      rethrow;
    }
  }

  @override
  Future<List<Notification>> fetchAllNotificationOfUser(String userId) async {
    List<Notification> notiList = [];

    var value = await ref
        .where(NotificationCollection.userId, isEqualTo: userId)
        .orderBy(NotificationCollection.fieldDateCreate, descending: true)
        .get();

    for (var doc in value.docs) {
      try {
        if (doc.data()[NotificationCollection.fieldType] ==
            NotiType.adminResponseUserRequest.value) {
          var notiRequest = NotiRequest.fromMap(doc.data());

          // TODO: fetch requestId
          // notiRequest.requestId = ...

          notiList.add(notiRequest);
        } else if (doc.data()[NotificationCollection.fieldType] ==
            NotiType.adminResponseSurvey.value) {
          var notiDoSurvey = NotiDoSurvey.fromMap(doc.data());

          // TODO: fetch doSurveyId
          // notiDoSurvey.doSurveyId = ...

          notiList.add(notiDoSurvey);
        }
      } catch (e) {
        Logger().e("add noti error", error: e);
      }
    }

    return [];
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
}
