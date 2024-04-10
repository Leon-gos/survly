import 'dart:convert';

import 'package:survly/src/network/model/user/user.dart';

enum SurveyRequestStatus {
  pending(value: "pending"),
  accepted(value: "accepted"),
  denied(value: "denied");

  final String value;

  const SurveyRequestStatus({required this.value});
}

class SurveyRequest {
  String requestId;
  String surveyId;
  String userId;
  String dateRequest;
  String status;
  String message;
  User? user;

  SurveyRequest({
    required this.requestId,
    required this.surveyId,
    required this.userId,
    required this.dateRequest,
    required this.status,
    required this.message,
    this.user,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'requestId': requestId,
      'surveyId': surveyId,
      'userId': userId,
      'dateRequest': dateRequest,
      'message': message,
      'status': status,
    };
  }

  factory SurveyRequest.fromMap(Map<String, dynamic> map) {
    return SurveyRequest(
      requestId: map['requestId']?.toString() ?? "",
      surveyId: map['surveyId']?.toString() ?? "",
      userId: map['userId']?.toString() ?? "",
      dateRequest: map['dateRequest']?.toString() ?? "",
      status: map['status']?.toString() ?? "",
      message: map['message']?.toString() ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory SurveyRequest.fromJson(String source) =>
      SurveyRequest.fromMap(json.decode(source) as Map<String, dynamic>);
}
