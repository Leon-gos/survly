import 'package:survly/src/network/model/notification/notification.dart';

abstract class NotificationRepository {
  Future<void> createNoti();
  Future<void> readNoti();
  Future<List<Notification>> fetchAllNotificationOfUser(String userId);
}
