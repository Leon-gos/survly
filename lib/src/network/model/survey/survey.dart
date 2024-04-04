import 'dart:convert';

class Survey {
  String surveyId;
  String thumbnail;
  String title;
  String description;
  int cost;
  String dateCreate;
  String dateUpdate;
  String dateStart;
  String dateEnd;
  int respondentMax;
  int respondentNum;
  String status;
  String outletId;
  final String adminId;

  Survey({
    required this.surveyId,
    this.thumbnail = "",
    this.title = "",
    this.description = "",
    this.cost = 0,
    required this.dateCreate,
    required this.dateUpdate,
    this.dateStart = "",
    this.dateEnd = "",
    this.respondentMax = 0,
    this.respondentNum = 0,
    required this.status,
    this.outletId = "",
    required this.adminId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'surveyId': surveyId,
      'thumbnail': thumbnail,
      'title': title,
      'description': description,
      'cost': cost,
      'dateCreate': dateCreate,
      'dateUpdate': dateUpdate,
      'dateStart': dateStart,
      'dateEnd': dateEnd,
      'respondentMax': respondentMax,
      'respondentNum': respondentNum,
      'status': status,
      'outletId': outletId,
      'adminId': adminId,
    };
  }

  factory Survey.fromMap(Map<String, dynamic> map) {
    return Survey(
      surveyId: map['surveyId']?.toString() ?? "",
      thumbnail: map['thumbnail']?.toString() ?? "",
      title: map['title']?.toString() ?? "",
      description: map['description']?.toString() ?? "",
      cost: int.parse(map['cost']?.toString() ?? "0"),
      dateCreate: map['dateCreate']?.toString() ?? "",
      dateUpdate: map['dateUpdate']?.toString() ?? "",
      dateStart: map['dateStart']?.toString() ?? "",
      dateEnd: map['dateEnd']?.toString() ?? "",
      respondentMax: int.parse(map['respondentMax']?.toString() ?? "0"),
      respondentNum: int.parse(map['respondentNum']?.toString() ?? "0"),
      status: map['status']?.toString() ?? "",
      outletId: map['outletId']?.toString() ?? "",
      adminId: map['adminId']?.toString() ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory Survey.fromJson(String source) =>
      Survey.fromMap(json.decode(source) as Map<String, dynamic>);
}
