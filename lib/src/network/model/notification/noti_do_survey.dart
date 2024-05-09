import 'dart:convert';

class NotiDoSurvey {
  String notiDoSurveyId;
  String doSurveyId;
  String notiId;
  NotiDoSurvey({
    required this.notiDoSurveyId,
    required this.doSurveyId,
    required this.notiId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'notiDoSurveyId': notiDoSurveyId,
      'doSurveyId': doSurveyId,
      'notiId': notiId,
    };
  }

  factory NotiDoSurvey.fromMap(Map<String, dynamic> map) {
    return NotiDoSurvey(
      notiDoSurveyId: map['notiDoSurveyId']?.toString() ?? "",
      doSurveyId: map['doSurveyId']?.toString() ?? "",
      notiId: map['notiId']?.toString() ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory NotiDoSurvey.fromJson(String source) =>
      NotiDoSurvey.fromMap(json.decode(source) as Map<String, dynamic>);
}
