import 'dart:convert';

class LocationLog {
  String doSurveyId;
  String dateCreate;
  double latitude;
  double longitude;

  LocationLog({
    required this.doSurveyId,
    required this.dateCreate,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'doSurveyId': doSurveyId,
      'dateCreate': dateCreate,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory LocationLog.fromMap(Map<String, dynamic> map) {
    return LocationLog(
      doSurveyId: map['doSurveyId']?.toString() ?? "",
      dateCreate: map['dateCreate']?.toString() ?? "",
      latitude: double.parse(map['latitude']?.toString() ?? "0"),
      longitude: double.parse(map['longitude']?.toString() ?? "0"),
    );
  }

  String toJson() => json.encode(toMap());

  factory LocationLog.fromJson(String source) =>
      LocationLog.fromMap(json.decode(source) as Map<String, dynamic>);
}
