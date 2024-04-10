import 'dart:convert';

import 'package:survly/src/config/constants/firebase_collections.dart';
import 'package:survly/src/network/model/outlet/outlet.dart';
import 'package:survly/src/network/model/question/question.dart';
import 'package:survly/src/network/model/user_base/user_base.dart';

enum SurveyStatus {
  draft(value: "draft"),
  public(value: "public"),
  archived(value: "archived");

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
  Outlet? outlet;
  String adminId;

  String? _getSurveyError() {
    if (thumbnail == "") {
      return "Thumbnail empty";
    }
    if (title == "") {
      return "Title empty";
    }
    if (description == "") {
      return "Description empty";
    }
    if (cost < 0) {
      return "Cost invalid";
    }
    if (dateStart == "") {
      return "Start date empty";
    }
    if (dateEnd == "") {
      return "End date empty";
    }
    if (respondentMax <= 0) {
      return "Respondent invalid";
    }

    String? outletError = outlet?.getError();
    if (outletError != null) {
      return outletError;
    }

    return null;
  }

  bool ableToEdit(String? adminId) {
    if (this.adminId != adminId) {
      return false;
    }
    if (status != SurveyStatus.draft.value) {
      return false;
    }
    return true;
  }

  String? getDraftError(String? adminId) {
    if (this.adminId != adminId) {
      return "Not have permission";
    }
    if (status != SurveyStatus.public.value) {
      return "Can only draft public survey";
    }
    if (respondentNum > 0) {
      return "Can only draft public with no respondent";
    }
    return null;
  }

  String? getPublishError(String? adminId, List<Question> questionList) {
    if (this.adminId != adminId) {
      return "Not have permission";
    }
    if (status != SurveyStatus.draft.value) {
      return "Can only publish draft survey";
    }

    String? surveyError = _getSurveyError();
    if (surveyError != null) {
      return surveyError;
    }

    if (questionList.isEmpty) {
      return "Empty question";
    }

    String? questionListError;
    for (var question in questionList) {
      questionListError = question.getError();
      if (questionListError != null) {
        break;
      }
    }
    if (questionListError != null) {
      return questionListError;
    }

    return null;
  }

  Survey({
    required this.surveyId,
    required this.thumbnail,
    required this.title,
    required this.description,
    required this.cost,
    required this.dateCreate,
    required this.dateUpdate,
    required this.dateStart,
    required this.dateEnd,
    required this.respondentMax,
    required this.respondentNum,
    required this.status,
    this.outlet,
    required this.adminId,
  });

  factory Survey.draft({
    surveyId = "",
    thumbnail = "",
    title = "",
    description = "",
    cost = 0,
    dateCreate = "",
    dateUpdate = "",
    dateStart = "",
    dateEnd = "",
    respondentMax = 0,
    respondentNum = 0,
    status = "",
    outlet,
    required adminId,
  }) {
    Survey survey = Survey(
      surveyId: surveyId,
      thumbnail: thumbnail,
      title: title,
      description: description,
      cost: cost,
      dateCreate: dateCreate,
      dateUpdate: dateUpdate,
      dateStart: dateStart,
      dateEnd: dateEnd,
      respondentMax: respondentMax,
      respondentNum: respondentNum,
      status: status,
      outlet: outlet,
      adminId: adminId,
    );
    survey.dateCreate =
        dateCreate != "" ? dateCreate : DateTime.now().toString();
    survey.dateUpdate =
        dateUpdate != "" ? dateUpdate : DateTime.now().toString();
    survey.status = SurveyStatus.draft.value;
    survey.adminId = adminId;
    return survey;
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
    Outlet? outlet,
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
      outlet: outlet ?? this.outlet,
      adminId: adminId ?? this.adminId,
    );
  }

  String genThumbnailImageFileKey() {
    return "${UserBase.roleAdmin}/${SurveyCollection.collectionName}/$surveyId";
  }
}
