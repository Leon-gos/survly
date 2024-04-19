import 'dart:convert';

import 'package:survly/src/config/constants/firebase_collections.dart';
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

  DoSurvey({
    required this.doSurveyId,
    this.currentLat,
    this.currentLng,
    this.photoOutlet,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'doSurveyId': doSurveyId,
      'currentLat': currentLat,
      'currentLng': currentLng,
      'photoOutlet': photoOutlet,
      'status': status,
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
  }) {
    return DoSurvey(
      doSurveyId: doSurveyId ?? this.doSurveyId,
      currentLat: currentLat ?? this.currentLat,
      currentLng: currentLng ?? this.currentLng,
      photoOutlet: photoOutlet ?? this.photoOutlet,
      status: status ?? this.status,
    );
  }

  String genPhotoOutletFileKey() {
    return "${UserBase.roleUser}/${DoSurveyCollection.collectionName}/$doSurveyId";
  }
}
