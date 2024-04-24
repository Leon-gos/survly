enum NotiType {
  adminResponseSurvey(value: "adminResponseSurvey"),
  userResponseSurvey(value: "userResponseSurvey");

  final String value;

  const NotiType({required this.value});
}

class NotiDataField {
  static const String type = "type";
  static const String data = "data";
}
