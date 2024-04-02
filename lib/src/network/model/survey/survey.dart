import 'dart:convert';
import 'dart:ffi';

class Survey {
  final String surveyId;
  final String title;
  final String description;
  final int cost;
  final String dateCreate;
  final String dateUpdate;
  final String status;
  final String outletId;
  final String adminId;

  Survey({
    required this.surveyId,
    required this.title,
    required this.description,
    required this.cost,
    required this.dateCreate,
    required this.dateUpdate,
    required this.status,
    required this.outletId,
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
      'status': status,
      'outletId': outletId,
      'adminId': adminId,
    };
  }

  factory Survey.fromMap(Map<String, dynamic> map) {
    return Survey(
      surveyId: map['surveyId'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      cost: map['cost'] as int,
      dateCreate: map['dateCreate'] as String,
      dateUpdate: map['dateUpdate'] as String,
      status: map['status'] as String,
      outletId: map['outletId'] as String,
      adminId: map['adminId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Survey.fromJson(String source) => Survey.fromMap(json.decode(source) as Map<String, dynamic>);
}
