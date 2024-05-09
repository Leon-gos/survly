import 'dart:convert';

class NotiRequestBody {
  Notification? notification;
  String? to;
  Map<String, dynamic>? data;

  NotiRequestBody({this.notification, this.to, this.data});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'notification': notification?.toMap(),
      'to': to,
      'data': data,
    };
  }

  factory NotiRequestBody.fromMap(Map<String, dynamic> map) {
    return NotiRequestBody(
      notification: map['notification'] != null
          ? Notification.fromMap(map['notification'] as Map<String, dynamic>)
          : null,
      to: map['to'] != null ? map['to'] as String : null,
      data: map['data'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NotiRequestBody.fromJson(String source) =>
      NotiRequestBody.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Notification {
  String? title;
  String? body;

  Notification({this.title, this.body});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'body': body,
    };
  }

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      title: map['title'] != null ? map['title'] as String : null,
      body: map['body'] != null ? map['body'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Notification.fromJson(String source) =>
      Notification.fromMap(json.decode(source) as Map<String, dynamic>);
}
