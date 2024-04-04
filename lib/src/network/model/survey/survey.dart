// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';

enum SurveyStatus {
  draft(value: "draft"),
  openning(value: "openning"),
  closed(value: "closed"),
  archive(value: "archived");

  final String value;
  const SurveyStatus({required this.value});
}

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
  String adminId;

  Survey({
    this.surveyId = "",
    this.thumbnail = "",
    this.title = "",
    this.description = "",
    this.cost = 0,
    this.dateCreate = "",
    this.dateUpdate = "",
    this.dateStart = "",
    this.dateEnd = "",
    this.respondentMax = 0,
    this.respondentNum = 0,
    this.status = "",
    this.outletId = "",
    this.adminId = "",
  }) {
    dateCreate = DateTime.now().toString();
    dateUpdate = DateTime.now().toString();
    status = SurveyStatus.draft.value;
    adminId = AdminSingleton.instance().admin?.id ?? "";
  }

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

  Survey copyWith({
    String? surveyId,
    String? thumbnail,
    String? title,
    String? description,
    int? cost,
    String? dateCreate,
    String? dateUpdate,
    String? dateStart,
    String? dateEnd,
    int? respondentMax,
    int? respondentNum,
    String? status,
    String? outletId,
    String? adminId,
  }) {
    return Survey(
      surveyId: surveyId ?? this.surveyId,
      thumbnail: thumbnail ?? this.thumbnail,
      title: title ?? this.title,
      description: description ?? this.description,
      cost: cost ?? this.cost,
      dateCreate: dateCreate ?? this.dateCreate,
      dateUpdate: dateUpdate ?? this.dateUpdate,
      dateStart: dateStart ?? this.dateStart,
      dateEnd: dateEnd ?? this.dateEnd,
      respondentMax: respondentMax ?? this.respondentMax,
      respondentNum: respondentNum ?? this.respondentNum,
      status: status ?? this.status,
      outletId: outletId ?? this.outletId,
      adminId: adminId ?? this.adminId,
    );
  }
}
