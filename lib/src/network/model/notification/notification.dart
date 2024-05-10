import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  String notiId;
  String title;
  String body;
  bool isRead;
  String type;
  DateTime dateCreate;
  String fromUserId;
  String toUserId;

  Notification({
    required this.notiId,
    required this.title,
    required this.body,
    required this.isRead,
    required this.type,
    required this.dateCreate,
    required this.fromUserId,
    required this.toUserId,
  });

  factory Notification.init({
    String? notiId,
    required String title,
    String? body,
    required String type,
    required String fromUserId,
    required String toUserId,
  }) {
    return Notification(
      notiId: notiId ?? "",
      title: title,
      body: body ?? "",
      isRead: false,
      type: type,
      dateCreate: DateTime.now(),
      fromUserId: fromUserId,
      toUserId: toUserId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'notiId': notiId,
      'title': title,
      'body': body,
      'isRead': isRead,
      'type': type,
      'dateCreate': dateCreate,
      'fromUserId': fromUserId,
      'toUserId': toUserId,
    };
  }

  Map<String, dynamic> toMapNoti() {
    return <String, dynamic>{
      'notiId': notiId,
      'title': title,
      'body': body,
      'isRead': isRead,
      'type': type,
      'dateCreate': dateCreate,
      'fromUserId': fromUserId,
      'toUserId': toUserId,
    };
  }

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      notiId: map['notiId']?.toString() ?? "",
      title: map['title']?.toString() ?? "",
      body: map['body']?.toString() ?? "",
      isRead: map['isRead'] as bool,
      type: map['type']?.toString() ?? "",
      dateCreate: (map['dateCreate'] as Timestamp).toDate(),
      fromUserId: map['fromUserId']?.toString() ?? "",
      toUserId: map['toUserId']?.toString() ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory Notification.fromJson(String source) =>
      Notification.fromMap(json.decode(source) as Map<String, dynamic>);
}
