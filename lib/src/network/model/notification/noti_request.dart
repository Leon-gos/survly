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
    required super.fromUserId,
    required super.toUserId,
    required this.notiRequestId,
    required this.requestId,
  });

  factory NotiRequest.init({
    String? notiId,
    required String title,
    String? body,
    required String type,
    required String fromUserId,
    required String toUserId,
    String? notiRequestId,
    required String requestId,
  }) {
    return NotiRequest(
      notiId: notiId ?? "",
      title: title,
      body: body ?? "",
      isRead: false,
      type: type,
      dateCreate: DateTime.now(),
      fromUserId: fromUserId,
      toUserId: toUserId,
      notiRequestId: notiRequestId ?? "",
      requestId: requestId,
    );
  }

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
      dateCreate: map['dateCreate'],
      fromUserId: map['fromUserId']?.toString() ?? "",
      toUserId: map['toUserId']?.toString() ?? "",
      notiRequestId: map['notiRequestId']?.toString() ?? "",
      requestId: map['requestId']?.toString() ?? "",
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory NotiRequest.fromJson(String source) =>
      NotiRequest.fromMap(json.decode(source) as Map<String, dynamic>);
}
