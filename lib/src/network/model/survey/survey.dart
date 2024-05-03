import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_geo_hash/geohash.dart';
import 'package:flutter_geo_hash/geohash.dart' as geohash;
import 'package:logger/logger.dart';
import 'package:survly/src/config/constants/firebase_collections.dart';
import 'package:survly/src/localization/localization_utils.dart';
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
  DateTime dateCreate;
  DateTime dateUpdate;
  DateTime? dateStart;
  DateTime? dateEnd;
  int respondentMax;
  int respondentNum;
  String status;
  Outlet? outlet;
  String adminId;
  List<String> searchList;

  String? _getSurveyError() {
    if (thumbnail == "") {
      return S.text.errorThumbnailEmpty;
    }
    if (title == "") {
      return S.text.errorTitleEmpty;
    }
    if (description == "") {
      return S.text.errorDescriptionEmpty;
    }
    if (cost < 0) {
      return S.text.errorCostInvalid;
    }
    if (dateStart == null) {
      return S.text.errorStartDateEmpty;
    }
    if (dateEnd == null) {
      return S.text.errorEndDateEmpty;
    }
    if (respondentMax <= 0) {
      return S.text.errorRespondentInvalid;
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

  bool ableToResponseRequest(String? adminId) {
    if (this.adminId != adminId) {
      return false;
    }
    if (status != SurveyStatus.public.value) {
      return false;
    }
    if (dateStart != null && !DateTime.now().isBefore(dateStart!)) {
      return false;
    }
    return true;
  }

  String? getDraftError(String? adminId) {
    if (this.adminId != adminId) {
      return S.text.errorNoPermission;
    }
    if (status != SurveyStatus.public.value) {
      return S.text.errorPublicToDraft;
    }
    if (respondentNum > 0) {
      return S.text.errorAlreadyHaveResponsent;
    }
    return null;
  }

  String? getPublishError(String? adminId, List<Question> questionList) {
    if (this.adminId != adminId) {
      return S.text.errorNoPermission;
    }
    if (status != SurveyStatus.draft.value) {
      return S.text.errorDraftToPublic;
    }

    String? surveyError = _getSurveyError();
    if (surveyError != null) {
      return surveyError;
    }

    if (questionList.isEmpty) {
      Logger().e(questionList.length);
      return S.text.errorQuestionEmpty;
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

  bool get ableToDoToday {
    try {
      var now = DateTime.now();
      var today = DateTime(now.year, now.month, now.day);
      return today.compareTo(dateStart!) >= 0 && today.compareTo(dateEnd!) <= 0;
    } catch (e) {
      return false;
    }
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
    this.searchList = const [],
  });

  factory Survey.draft({
    surveyId = "",
    thumbnail = "",
    title = "",
    description = "",
    cost = 0,
    dateCreate,
    dateUpdate,
    dateStart,
    dateEnd,
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
      dateCreate: DateTime.now(),
      dateUpdate: DateTime.now(),
      dateStart: dateStart,
      dateEnd: dateEnd,
      respondentMax: respondentMax,
      respondentNum: respondentNum,
      status: status,
      adminId: adminId,
    );
    survey.dateCreate = dateCreate ?? DateTime.now();
    survey.dateUpdate = dateUpdate ?? DateTime.now();
    survey.status = SurveyStatus.draft.value;
    survey.outlet = Outlet();
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
      'searchList': searchList,
    };
  }

  factory Survey.fromMap(Map<String, dynamic> map) {
    return Survey(
      surveyId: map['surveyId']?.toString() ?? "",
      thumbnail: map['thumbnail']?.toString() ?? "",
      title: map['title']?.toString() ?? "",
      description: map['description']?.toString() ?? "",
      cost: int.parse(map['cost']?.toString() ?? "0"),
      dateCreate: (map['dateCreate'] as Timestamp).toDate(),
      dateUpdate: (map['dateUpdate'] as Timestamp).toDate(),
      dateStart: map['dateStart'] != null
          ? (map['dateStart'] as Timestamp).toDate()
          : null,
      dateEnd: map['dateEnd'] != null
          ? (map['dateEnd'] as Timestamp).toDate()
          : null,
      respondentMax: int.parse(map['respondentMax']?.toString() ?? "0"),
      respondentNum: int.parse(map['respondentNum']?.toString() ?? "0"),
      status: map['status']?.toString() ?? "",
      adminId: map['adminId']?.toString() ?? "",
      outlet: Outlet(
        address: map[SurveyCollection.fieldAddress],
        // latitude: map[SurveyCollection.fieldLatitude],
        // longitude: map[SurveyCollection.fieldLongitude],
        geoPoint: map[SurveyCollection.fieldGeoPoint],
        geoHash: map[SurveyCollection.fieldGeoHash],
      ),
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
    DateTime? dateCreate,
    DateTime? dateUpdate,
    DateTime? dateStart,
    DateTime? dateEnd,
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

  void genSearchList() {
    var setWord = Set.from(title.toLowerCase().trim().split(" "));
    Set<String> setKeyword = {};
    for (String word in setWord) {
      for (int i = 0; i < word.length; i++) {
        for (int j = i + 1; j < word.length + 1; j++) {
          setKeyword.add(word.substring(i, j));
        }
      }
    }
    searchList = List.from(setKeyword);
  }

  void genGeohash() {
    try {
      if (outlet?.hasCoordinate() == true) {
        outlet?.geoHash = MyGeoHash().geoHashForLocation(geohash.GeoPoint(
          outlet!.geoPoint!.latitude,
          outlet!.geoPoint!.longitude,
        ));
      }
    } catch (e) {
      Logger().e("gen geohash error", error: e);
    }
  }
}
