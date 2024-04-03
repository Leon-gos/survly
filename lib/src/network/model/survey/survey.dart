import 'dart:convert';

class Survey {
  final String surveyId;
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
      surveyId: map['surveyId'] as String,
      thumbnail: map['thumbnail'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      cost: map['cost'] as int,
      dateCreate: map['dateCreate'] as String,
      dateUpdate: map['dateUpdate'] as String,
      dateStart: map['dateStart'] as String,
      dateEnd: map['dateEnd'] as String,
      respondentMax: map['respondentMax'] as int,
      respondentNum: map['respondentNum'] as int,
      status: map['status'] as String,
      outletId: map['outletId'] as String,
      adminId: map['adminId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Survey.fromJson(String source) => Survey.fromMap(json.decode(source) as Map<String, dynamic>);
}
