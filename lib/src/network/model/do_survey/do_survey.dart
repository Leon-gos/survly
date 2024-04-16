import 'dart:convert';

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
      doSurveyId: map['doSurveyId']?.toString() ?? "",
      currentLat: double.tryParse(map['currentLat']?.toString() ?? "0"),
      currentLng: double.tryParse(map['currentLng']?.toString() ?? "0"),
      status: map['status']?.toString() ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory DoSurvey.fromJson(String source) =>
      DoSurvey.fromMap(json.decode(source) as Map<String, dynamic>);

  DoSurvey copyWith({
    String? doSurveyId,
    double? currentLat,
    double? currentLng,
    String? status,
  }) {
    return DoSurvey(
      doSurveyId: doSurveyId ?? this.doSurveyId,
      currentLat: currentLat ?? this.currentLat,
      currentLng: currentLng ?? this.currentLng,
      status: status ?? this.status,
    );
  }
}
