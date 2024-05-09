import 'package:flutter/material.dart';
import 'package:survly/src/network/model/notification/notification.dart'
    as my_noti;

class NotiCard extends StatelessWidget {
  const NotiCard({
    super.key,
    required this.notification,
  });

  final my_noti.Notification notification;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(notification.title),
      subtitle: Text(notification.body),
    );
  }
}
