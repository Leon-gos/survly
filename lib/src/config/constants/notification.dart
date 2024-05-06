enum NotiType {
  adminResponseSurvey(value: "adminResponseSurvey"),
  userResponseSurvey(value: "userResponseSurvey"),
  userRequestSurvey(value: "userRequestSurvey"),
  adminResponseUserRequest(value: "adminResponseUserRequest");

  final String value;

  const NotiType({required this.value});
}

class NotiDataField {
  static const String type = "type";
  static const String data = "data";
}

class NotiDataDataKey {
  static const String surveyId = "surveyId";
}
