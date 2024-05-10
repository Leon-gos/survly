import 'dart:convert';

import 'package:survly/src/network/model/notification/notification.dart';

class NotiDoSurvey extends Notification {
  String notiDoSurveyId;
  String doSurveyId;

  NotiDoSurvey({
    required super.notiId,
    required super.title,
    required super.body,
    required super.isRead,
    required super.type,
    required super.dateCreate,
    required super.fromUserId,
    required super.toUserId,
    required this.notiDoSurveyId,
    required this.doSurveyId,
  });

  factory NotiDoSurvey.init({
    String? notiId,
    required String title,
    String? body,
    required String type,
    required String fromUserId,
    required String toUserId,
    String? notiRequestId,
    required String doSurveyId,
  }) {
    return NotiDoSurvey(
      notiId: notiId ?? "",
      title: title,
      body: body ?? "",
      isRead: false,
      type: type,
      dateCreate: DateTime.now(),
      fromUserId: fromUserId,
      toUserId: toUserId,
      notiDoSurveyId: notiRequestId ?? "",
      doSurveyId: doSurveyId,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'notiDoSurveyId': notiDoSurveyId,
      'doSurveyId': doSurveyId,
      'notiId': notiId,
    };
  }

  factory NotiDoSurvey.fromMap(Map<String, dynamic> map) {
    return NotiDoSurvey(
      notiId: map['notiId']?.toString() ?? "",
      title: map['title']?.toString() ?? "",
      body: map['body']?.toString() ?? "",
      isRead: map['isRead'] as bool,
      type: map['type']?.toString() ?? "",
      dateCreate: map['dateCreate'],
      fromUserId: map['fromUserId']?.toString() ?? "",
      toUserId: map['toUserid']?.toString() ?? "",
      notiDoSurveyId: map['notiDoSurveyId']?.toString() ?? "",
      doSurveyId: map['doSurveyId']?.toString() ?? "",
    );
  }

  @override
  String toJson() => json.encode(toMap());

  factory NotiDoSurvey.fromJson(String source) =>
      NotiDoSurvey.fromMap(json.decode(source) as Map<String, dynamic>);
}
