import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_geo_hash/geohash.dart' as geohash;
import 'package:flutter_geo_hash/geohash.dart';
import 'package:logger/logger.dart';
import 'package:logger/web.dart';
import 'package:survly/src/config/constants/firebase_collections.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/network/data/do_survey/do_survey_repository_impl.dart';
import 'package:survly/src/network/data/file/file_data.dart';
import 'package:survly/src/network/data/question/question_repository_impl.dart';
import 'package:survly/src/network/data/survey/survey_repository.dart';
import 'package:survly/src/network/model/question/question.dart';
import 'package:survly/src/network/model/survey/survey.dart';

class SurveyRepositoryImpl implements SurveyRepository {
  final ref =
      FirebaseFirestore.instance.collection(SurveyCollection.collectionName);

  static const int pageSize = 3;

  @override
  Future<List<Survey>> fetchFirstPageSurvey({String? searchKeyword}) async {
    List<Survey> list = [];

    QuerySnapshot<Map<String, dynamic>> value;
    if (searchKeyword != null && searchKeyword != "") {
      value = await ref
          .where(
            SurveyCollection.fieldStatus,
            isNotEqualTo: SurveyStatus.archived.value,
          )
          .orderBy(SurveyCollection.fieldStatus)
          .where(
            SurveyCollection.fieldSearchList,
            arrayContainsAny:
                List.from(searchKeyword.toLowerCase().trim().split(" ")),
          )
          .limit(pageSize)
          .get();
    } else {
      value = await ref
          .where(
            SurveyCollection.fieldStatus,
            isNotEqualTo: SurveyStatus.archived.value,
          )
          .orderBy(SurveyCollection.fieldStatus)
          .limit(pageSize)
          .get();
    }

    for (var doc in value.docs) {
      var data = doc.data();
      data[SurveyCollection.fieldSurveyId] = doc.id;
      var survey = Survey.fromMap(data);
      list.add(survey);
    }

    return list;
  }

  @override
  Future<List<Survey>> fetchMoreSurvey({
    required Survey lastSurvey,
    String? searchKeyword,
  }) async {
    List<Survey> list = [];
    var lastDoc = await ref.doc(lastSurvey.surveyId).get();

    QuerySnapshot<Map<String, dynamic>> value;
    if (searchKeyword != null && searchKeyword != "") {
      value = await ref
          .where(
            SurveyCollection.fieldStatus,
            isNotEqualTo: SurveyStatus.archived.value,
          )
          .orderBy(SurveyCollection.fieldStatus)
          .where(
            SurveyCollection.fieldSearchList,
            arrayContainsAny:
                List.from(searchKeyword.toLowerCase().trim().split(" ")),
          )
          .startAfterDocument(lastDoc)
          .limit(pageSize)
          .get();
    } else {
      value = await ref
          .where(
            SurveyCollection.fieldStatus,
            isNotEqualTo: SurveyStatus.archived.value,
          )
          .orderBy(SurveyCollection.fieldStatus)
          .limit(pageSize)
          .startAfterDocument(lastDoc)
          .get();
    }
    for (var doc in value.docs) {
      var data = doc.data();

      if (data[SurveyCollection.fieldStatus] == SurveyStatus.archived.value) {
        continue;
      }

      data[SurveyCollection.fieldSurveyId] = doc.id;
      var survey = Survey.fromMap(data);
      list.add(survey);
    }

    return list;
  }

  @override
  Future<void> createSurvey({
    required Survey survey,
    required String fileLocalPath,
    required List<Question> questionList,
  }) async {
    try {
      // 1: insert survey
      survey.adminId = UserBaseSingleton.instance().userBase!.id;
      final value = await ref.add({});
      survey.surveyId = value.id;
      survey.genGeohash();
      survey.genSearchList();
      ref.doc("/${value.id}").set({
        ...survey.toMap(),
        ...(survey.outlet?.toMap() ?? {}),
      });

      if (fileLocalPath == "") {
        return;
      }

      // 2: upload image
      Logger().d(fileLocalPath);
      String? imageUrl = await FileData.instance().uploadFileImage(
        filePath: fileLocalPath,
        fileKey: survey.genThumbnailImageFileKey(),
      );

      // 3: update survey thumbnail
      ref.doc(survey.surveyId).update({
        SurveyCollection.fieldThumbnail: imageUrl,
      });

      // 4: insert questions of survey
      var questionRepo = QuestionRepositoryImpl();
      for (var question in questionList) {
        question.surveyId = survey.surveyId;
        questionRepo.createQuestion(question);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateSurvey({
    required Survey survey,
    required String fileLocalPath,
    required List<Question> questionList,
  }) async {
    try {
      // 1: insert survey
      survey.genGeohash();
      survey.genSearchList();
      ref.doc("/${survey.surveyId}").set({
        ...survey.toMap(),
        ...(survey.outlet?.toMap() ?? {}),
        SurveyCollection.fieldDateUpdate: DateTime.now(),
      });

      if (fileLocalPath != "") {
        // 2.1: upload image
        Logger().d(fileLocalPath);
        String? imageUrl = await FileData.instance().uploadFileImage(
          filePath: fileLocalPath,
          fileKey: survey.genThumbnailImageFileKey(),
        );

        // 2.2: update survey thumbnail
        ref.doc(survey.surveyId).update({
          SurveyCollection.fieldThumbnail: imageUrl,
        });
      }

      // 3: insert questions of survey
      var questionRepo = QuestionRepositoryImpl();

      // 3.1: remove all old question
      await questionRepo.deleteAllQuestionOfSurvey(survey.surveyId);

      // 3.2: reinsert questions
      for (var question in questionList) {
        question.surveyId = survey.surveyId;
        questionRepo.createQuestion(question);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Survey?> fetchSurveyById(String surveyId) async {
    try {
      var value = await ref
          .where(SurveyCollection.fieldSurveyId, isEqualTo: surveyId)
          .get();
      var data = value.docs[0].data();
      Survey survey = Survey.fromMap(data);
      return survey;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> changeSurveyStatus(String surveyId, String newStatus) async {
    try {
      await ref.doc(surveyId).update({
        SurveyCollection.fieldStatus: newStatus,
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Survey>> fetchFirstPageExploreSurvey({
    String? searchKeyword,
  }) async {
    List<Survey> list = [];

    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day, 0, 0);

    QuerySnapshot<Map<String, dynamic>> value;
    if (searchKeyword != null) {
      value = await ref
          .orderBy(SurveyCollection.fieldDateStart)
          .where(
            SurveyCollection.fieldDateStart,
            isGreaterThan: Timestamp.fromDate(today),
          )
          .where(SurveyCollection.fieldStatus,
              isEqualTo: SurveyStatus.public.value)
          .where(
            SurveyCollection.fieldSearchList,
            arrayContainsAny: List.from(
              searchKeyword.toLowerCase().trim().split(" "),
            ),
          )
          .limit(pageSize)
          .get();
    } else {
      value = await ref
          .orderBy(SurveyCollection.fieldDateStart)
          .where(
            SurveyCollection.fieldDateStart,
            isGreaterThan: Timestamp.fromDate(today),
          )
          .where(SurveyCollection.fieldStatus,
              isEqualTo: SurveyStatus.public.value)
          .limit(pageSize)
          .get();
    }

    for (var doc in value.docs) {
      var data = doc.data();
      data[SurveyCollection.fieldSurveyId] = doc.id;
      var survey = Survey.fromMap(data);
      list.add(survey);
    }

    return list;
  }

  @override
  Future<List<Survey>> fetchMoreExploreSurvey({
    required Survey lastSurvey,
    String? searchKeyword,
  }) async {
    List<Survey> list = [];

    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day, 0, 0);

    var lastDoc = await ref.doc(lastSurvey.surveyId).get();

    QuerySnapshot<Map<String, dynamic>> value;
    if (searchKeyword != null) {
      value = await ref
          .orderBy(SurveyCollection.fieldDateStart)
          .where(
            SurveyCollection.fieldDateStart,
            isGreaterThan: Timestamp.fromDate(today),
          )
          .where(SurveyCollection.fieldStatus,
              isEqualTo: SurveyStatus.public.value)
          .where(
            SurveyCollection.fieldSearchList,
            arrayContainsAny: List.from(
              searchKeyword.toLowerCase().trim().split(" "),
            ),
          )
          .startAfterDocument(lastDoc)
          .limit(pageSize)
          .get();
    } else {
      value = await ref
          .orderBy(SurveyCollection.fieldDateStart)
          .where(
            SurveyCollection.fieldDateStart,
            isGreaterThan: Timestamp.fromDate(today),
          )
          .where(SurveyCollection.fieldStatus,
              isEqualTo: SurveyStatus.public.value)
          .startAfterDocument(lastDoc)
          .limit(pageSize)
          .get();
    }

    for (var doc in value.docs) {
      var data = doc.data();

      if (data[SurveyCollection.fieldStatus] == SurveyStatus.archived.value) {
        continue;
      }

      data[SurveyCollection.fieldSurveyId] = doc.id;
      var survey = Survey.fromMap(data);
      list.add(survey);
    }

    return list;
  }

  @override
  Future<List<Survey>> fetchFirstPageExploreSurveyNearBy({
    required double km,
    required geohash.GeoPoint geoPoint,
    String? searchKeyword,
  }) async {
    List<Survey> list = [];

    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);

    List<List<String>> bounds =
        MyGeoHash().geohashQueryBounds(geoPoint, km * 1000);

    for (List<String> b in bounds) {
      if (list.length >= pageSize) {
        break;
      }
      QuerySnapshot<Map<String, dynamic>> value;
      if (searchKeyword != null) {
        value = await ref
            .where(
              SurveyCollection.fieldStatus,
              isEqualTo: SurveyStatus.public.value,
            )
            .where(
              SurveyCollection.fieldSearchList,
              arrayContainsAny: List.from(
                searchKeyword.toLowerCase().trim().split(" "),
              ),
            )
            .orderBy(SurveyCollection.fieldGeoHash)
            .startAt([b[0]]).endAt([b[1]]).get();
      } else {
        value = await ref
            .where(
              SurveyCollection.fieldStatus,
              isEqualTo: SurveyStatus.public.value,
            )
            .orderBy(SurveyCollection.fieldGeoHash)
            .startAt([b[0]]).endAt([b[1]]).get();
      }

      for (var doc in value.docs) {
        var data = doc.data();
        data[SurveyCollection.fieldSurveyId] = doc.id;
        var survey = Survey.fromMap(data);
        if (today.compareTo(survey.dateStart!) < 0) {
          list.add(survey);
        }
        if (list.length >= pageSize) {
          break;
        }
      }
    }

    return list;
  }

  @override
  Future<List<Survey>> fetchMoreExploreSurveyNearBy({
    required double km,
    required geohash.GeoPoint geoPoint,
    required Survey lastSurvey,
    String? searchKeyword,
  }) async {
    List<Survey> list = [];

    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day, 0, 0);

    List<List<String>> bounds =
        MyGeoHash().geohashQueryBounds(geoPoint, km * 1000);

    for (List<String> b in bounds) {
      if (list.length >= pageSize) {
        break;
      }
      QuerySnapshot<Map<String, dynamic>> value;

      if (searchKeyword != null) {
        value = await ref
            .where(
              SurveyCollection.fieldStatus,
              isEqualTo: SurveyStatus.public.value,
            )
            .where(
              SurveyCollection.fieldSearchList,
              arrayContainsAny: List.from(
                searchKeyword.toLowerCase().trim().split(" "),
              ),
            )
            .orderBy(SurveyCollection.fieldGeoHash)
            .startAt([b[0]])
            .endAt([b[1]])
            .startAfterDocument(await ref.doc(lastSurvey.surveyId).get())
            .get();
      } else {
        value = await ref
            .where(
              SurveyCollection.fieldStatus,
              isEqualTo: SurveyStatus.public.value,
            )
            .orderBy(SurveyCollection.fieldGeoHash)
            .startAt([b[0]])
            .endAt([b[1]])
            .startAfterDocument(await ref.doc(lastSurvey.surveyId).get())
            .get();
      }
      for (var doc in value.docs) {
        var data = doc.data();
        data[SurveyCollection.fieldSurveyId] = doc.id;
        var survey = Survey.fromMap(data);
        if (today.compareTo(survey.dateStart!) < 0) {
          list.add(survey);
        }
        if (list.length >= pageSize) {
          break;
        }
      }
    }

    return list;
  }

  Future<List<Survey>> fetchUserDoingSurvey(String userId) async {
    List<Survey> list = [];
    var doSurveyRepo = DoSurveyRepositoryImpl();
    var surveyIdList = await doSurveyRepo.fetchUserDoingSurveyId(userId);
    for (var surveyId in surveyIdList) {
      var survey = await fetchSurveyById(surveyId);
      if (survey != null && survey.ableToDoToday) {
        list.add(survey);
      }
    }
    return list;
  }

  @override
  Future<void> increaseSurveyRespondentNum(String surveyId) async {
    try {
      var value = await ref.doc(surveyId).get();
      await ref.doc(surveyId).update({
        SurveyCollection.fieldRespondentNum:
            value.data()?[SurveyCollection.fieldRespondentNum] + 1,
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Survey>> fetchAdminSurveyList(String? adminId) async {
    List<Survey> list = [];
    if (adminId != null) {
      var value = await ref
          .where(SurveyCollection.fieldAdminId, isEqualTo: adminId)
          .where(SurveyCollection.fieldStatus,
              isNotEqualTo: SurveyStatus.archived.value)
          .get();
      for (var doc in value.docs) {
        var survey = Survey.fromMap({
          ...doc.data(),
          SurveyCollection.fieldSurveyId: doc.id,
        });
        list.add(survey);
      }
    }

    return list;
  }
}
