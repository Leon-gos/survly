import 'package:survly/src/network/model/notification/notification.dart';

abstract class NotificationRepository {
  Future<void> createNoti(Notification notification);
  Future<void> readNoti(String notiId);
  Future<List<Notification>> fetchAllNotificationOfUser(String userId);
}
