import 'dart:convert';

import 'package:survly/src/config/constants/firebase_collections.dart';
import 'package:survly/src/network/model/user/user.dart';
import 'package:survly/src/network/model/user_base/user_base.dart';

enum DoSurveyStatus {
  doing(value: "doing"),
  submitted(value: "submitted"),
  approved(value: "approved"),
  ignored(value: "ignored");

  final String value;

  const DoSurveyStatus({required this.value});
}

class DoSurvey {
  String doSurveyId;
  double? currentLat;
  double? currentLng;
  String? photoOutlet;
  String status;
  String dateUpdate;
  String surveyId;
  String userId;
  User? user;

  DoSurvey({
    required this.doSurveyId,
    this.currentLat,
    this.currentLng,
    this.photoOutlet,
    required this.status,
    required this.dateUpdate,
    required this.surveyId,
    required this.userId,
    this.user,
  });

  factory DoSurvey.init({
    required String surveyId,
    required String userId,
  }) {
    return DoSurvey(
        doSurveyId: "",
        status: DoSurveyStatus.doing.value,
        dateUpdate: DateTime.now().toString(),
        surveyId: surveyId,
        userId: userId);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'doSurveyId': doSurveyId,
      'currentLat': currentLat,
      'currentLng': currentLng,
      'photoOutlet': photoOutlet,
      'status': status,
      'dateUpdate': dateUpdate,
      'surveyId': surveyId,
      'userId': userId,
    };
  }

  factory DoSurvey.fromMap(Map<String, dynamic> map) {
    return DoSurvey(
      doSurveyId: map['doSurveyId'] as String,
      currentLat:
          map['currentLat'] != null ? map['currentLat'] as double : null,
      currentLng:
          map['currentLng'] != null ? map['currentLng'] as double : null,
      photoOutlet:
          map['photoOutlet'] != null ? map['photoOutlet'] as String : null,
      status: map['status'] as String,
      dateUpdate: map['dateUpdate']?.toString() ?? "",
      surveyId: map['surveyId']?.toString() ?? "",
      userId: map['userId']?.toString() ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory DoSurvey.fromJson(String source) =>
      DoSurvey.fromMap(json.decode(source) as Map<String, dynamic>);

  DoSurvey copyWith({
    String? doSurveyId,
    double? currentLat,
    double? currentLng,
    String? photoOutlet,
    String? status,
    String? dateUpdate,
    String? surveyId,
    String? userId,
    User? user,
  }) {
    return DoSurvey(
      doSurveyId: doSurveyId ?? this.doSurveyId,
      currentLat: currentLat ?? this.currentLat,
      currentLng: currentLng ?? this.currentLng,
      photoOutlet: photoOutlet ?? this.photoOutlet,
      status: status ?? this.status,
      dateUpdate: dateUpdate ?? this.dateUpdate,
      surveyId: surveyId ?? this.surveyId,
      userId: userId ?? this.userId,
      user: user ?? this.user,
    );
  }

  String genPhotoOutletFileKey() {
    return "${UserBase.roleUser}/${DoSurveyCollection.collectionName}/$doSurveyId";
  }
}
