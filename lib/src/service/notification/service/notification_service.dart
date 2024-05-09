import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/config/constants/notification.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/network/data/survey/survey_repository_impl.dart';
import 'package:survly/src/network/data/user/user_repository_impl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:survly/src/network/model/notification/noti_request_body.dart';
import 'package:survly/src/router/coordinator.dart';
import 'package:survly/src/router/router_name.dart';

class NotificationService {
  static Future<void> sendNotiToOneDevice({
    required NotiRequestBody requestBody,
  }) async {
    if (requestBody.to == null) {
      return;
    }
    Logger().d("start");
    Map<String, String> header = {
      "Authorization": "key=${dotenv.env["FCM_SERVER_KEY"]}",
      "Content-Type": "application/json; charset=UTF-8",
    };
    var value = await http.post(
      Uri.https(
        'fcm.googleapis.com',
        '/fcm/send',
      ),
      headers: header,
      body: requestBody.toJson(),
    );
    Logger().d(value.body);
    Logger().d("end");
  }

  static Future<void> sendNotiToUserById({
    required NotiRequestBody requestBody,
    required String? userId,
  }) async {
    if (userId == null) {
      return;
    }
    requestBody.to = await UserRepositoryImpl().fetchUserFcmToken(userId);
    if (requestBody.to == null) {
      return;
    }
    Map<String, String> header = {
      "Authorization": "key=${dotenv.env["FCM_SERVER_KEY"]}",
      "Content-Type": "application/json; charset=UTF-8",
    };
    var value = await http.post(
      Uri.https(
        'fcm.googleapis.com',
        '/fcm/send',
      ),
      headers: header,
      body: requestBody.toJson(),
    );
    Logger().d(value.body);
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

  static Future<void> deleteToken() async {
    await FirebaseMessaging.instance.deleteToken();
  }

  static void setupLocalNoti() {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        if (notification != null && android != null) {
          const AndroidNotificationChannel channel = AndroidNotificationChannel(
            'high_importance_channel',
            'High Importance Notifications',
            description:
                'This channel is used for important notifications.', // description
            importance: Importance.max,
          );

          final FlutterLocalNotificationsPlugin
              flutterLocalNotificationsPlugin =
              FlutterLocalNotificationsPlugin();

          flutterLocalNotificationsPlugin.initialize(
            const InitializationSettings(
              android: AndroidInitializationSettings("@mipmap/ic_launcher"),
            ),
            onDidReceiveNotificationResponse: (details) {
              _handleMessage(message);
            },
          );

          await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.createNotificationChannel(channel);

          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
              ),
            ),
          );
        }
      },
    );
  }

  static Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  static Future<void> _handleMessage(RemoteMessage message) async {
    String? type = message.data[NotiDataField.type];
    String? data = message.data[NotiDataField.data];

    if (type == NotiType.adminResponseSurvey.value) {
      AppCoordinator.context.push(AppRouteNames.myProfile.path);
    } else if (type == NotiType.userResponseSurvey.value) {
      if (data != null) {
        var extra = jsonDecode(data);
        extra = List<String>.from(extra);
        AppCoordinator.context.push(
          AppRouteNames.responseUserSurvey.path,
          extra: extra,
        );
      }
    } else if (type == NotiType.userRequestSurvey.value) {
      if (data != null) {
        var surveyId = (jsonDecode(data)
            as Map<String, dynamic>)[NotiDataDataKey.surveyId];
        AppCoordinator.context.push(
          AppRouteNames.surveyRequest.path,
          extra: await SurveyRepositoryImpl().fetchSurveyById(surveyId),
        );
      }
    } else if (type == NotiType.adminResponseUserRequest.value) {
      if (data != null) {
        var surveyId = (jsonDecode(data)
            as Map<String, dynamic>)[NotiDataDataKey.surveyId];
        AppCoordinator.context.push(
          AppRouteNames.previewSurvey.path,
          extra: await SurveyRepositoryImpl().fetchSurveyById(surveyId),
        );
      }
    }
  }
}
