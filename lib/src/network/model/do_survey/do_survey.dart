import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
enum DoSurveyStatus {
  doing(value: "doing"),
  approved(value: "approved"),
  ignored(value: "ignored");

  final String value;

  const DoSurveyStatus({required this.value});
}

class DoSurvey {
  String doSurveyId;
  double? currentLat;
  double? currentLng;
  String status;

  DoSurvey({
    required this.doSurveyId,
    this.currentLat,
    this.currentLng,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'doSurveyId': doSurveyId,
      'currentLat': currentLat,
      'currentLng': currentLng,
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
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DoSurvey.fromJson(String source) =>
      DoSurvey.fromMap(json.decode(source) as Map<String, dynamic>);
}
