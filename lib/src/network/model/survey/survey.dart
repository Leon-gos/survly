import 'dart:convert';

class Survey {
  final String surveyId;
  String? title;
  String? description;
  int? cost;
  String dateCreate;
  String dateUpdate;
  String? dateStart;
  String? dateEnd;
  String status;
  String? outletId;
  final String adminId;

  Survey({
    required this.surveyId,
    this.title,
    this.description,
    this.cost,
    required this.dateCreate,
    required this.dateUpdate,
    this.dateStart,
    this.dateEnd,
    required this.status,
    this.outletId,
    required this.adminId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'surveyId': surveyId,
      'title': title,
      'description': description,
      'cost': cost,
      'dateCreate': dateCreate,
      'dateUpdate': dateUpdate,
      'dateStart': dateStart,
      'dateEnd': dateEnd,
      'status': status,
      'outletId': outletId,
      'adminId': adminId,
    };
  }

  factory Survey.fromMap(Map<String, dynamic> map) {
    return Survey(
      surveyId: map['surveyId'] as String,
      title: map['title'] != null ? map['title'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      cost: map['cost'] != null ? map['cost'] as int : null,
      dateCreate: map['dateCreate'] as String,
      dateUpdate: map['dateUpdate'] as String,
      dateStart: map['dateStart'] != null ? map['dateStart'] as String : null,
      dateEnd: map['dateEnd'] != null ? map['dateEnd'] as String : null,
      status: map['status'] as String,
      outletId: map['outletId'] != null ? map['outletId'] as String : null,
      adminId: map['adminId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Survey.fromJson(String source) => Survey.fromMap(json.decode(source) as Map<String, dynamic>);
}
