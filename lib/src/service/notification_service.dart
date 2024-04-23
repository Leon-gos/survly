import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/network/data/user/user_repository_impl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NotificationService {
  static Future<void> sendNotiToOneDevice({
    required String notiTitle,
    required String notiBody,
    required String? fcmToken,
  }) async {
    if (fcmToken == null) {
      return;
    }
    Logger().d("start");
    Map<String, String> header = {
      "Authorization": "key=${dotenv.env["FCM_SERVER_KEY"]}",
      "Content-Type": "application/json; charset=UTF-8",
    };
    var body = {
      "notification": {
        "title": notiTitle,
        "body": notiBody,
      },
      "priority": "high",
      "to": fcmToken,
    };
    var value = await http.post(
      Uri.https(
        'fcm.googleapis.com',
        '/fcm/send',
      ),
      headers: header,
      body: jsonEncode(body),
    );
    Logger().d(value.body);
    Logger().d("end");
  }

  static Future<void> registerToken() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      var userId = UserBaseSingleton.instance().userBase?.id;
      if (userId != null) {
        UserRepositoryImpl().updateUserNotiToken(userId, fcmToken);
      }
    }
  }
}
