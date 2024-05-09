import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:survly/src/network/model/notification/notification.dart';

class NotiRequest extends Notification {
  String notiRequestId;
  String requestId;

  NotiRequest({
    required super.notiId,
    required super.title,
    required super.body,
    required super.isRead,
    required super.type,
    required super.dateCreate,
    required super.userId,
    required this.notiRequestId,
    required this.requestId,
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'notiRequestId': notiRequestId,
      'requestId': requestId,
      'notiId': notiId,
    };
  }

  factory NotiRequest.fromMap(Map<String, dynamic> map) {
    return NotiRequest(
      notiId: map['notiId']?.toString() ?? "",
      title: map['title']?.toString() ?? "",
      body: map['body']?.toString() ?? "",
      isRead: map['isRead'] as bool,
      type: map['type']?.toString() ?? "",
      dateCreate: (map['dateCreate'] as Timestamp).toDate(),
      userId: map['userId']?.toString() ?? "",
      notiRequestId: map['notiRequestId']?.toString() ?? "",
      requestId: map['requestId']?.toString() ?? "",
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory NotiRequest.fromJson(String source) =>
      NotiRequest.fromMap(json.decode(source) as Map<String, dynamic>);
}
