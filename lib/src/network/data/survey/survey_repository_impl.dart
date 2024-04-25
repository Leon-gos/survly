import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:logger/web.dart';
import 'package:survly/src/config/constants/firebase_collections.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/network/data/do_survey/do_survey_repository_impl.dart';
import 'package:survly/src/network/data/file/file_data.dart';
import 'package:survly/src/network/data/question/question_repository_impl.dart';
import 'package:survly/src/network/data/survey/survey_repository.dart';
import 'package:survly/src/network/model/outlet/outlet.dart';
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
      survey.outlet = Outlet(
        address: data[SurveyCollection.fieldAddress],
        latitude: data[SurveyCollection.fieldLatitude],
        longitude: data[SurveyCollection.fieldLongitude],
      );
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
      survey.outlet = Outlet(
        address: data[SurveyCollection.fieldAddress],
        latitude: data[SurveyCollection.fieldLatitude],
        longitude: data[SurveyCollection.fieldLongitude],
      );
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
      survey.genSearchList();
      ref.doc("/${survey.surveyId}").set({
        ...survey.toMap(),
        ...(survey.outlet?.toMap() ?? {}),
        SurveyCollection.fieldDateUpdate: DateTime.now().toString(),
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
      survey.outlet = Outlet(
        address: data[SurveyCollection.fieldAddress],
        latitude: data[SurveyCollection.fieldLatitude],
        longitude: data[SurveyCollection.fieldLongitude],
      );
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
  Future<List<Survey>> fetchFirstPageExploreSurvey() async {
    List<Survey> list = [];

    var value = await ref
        .where(
          SurveyCollection.fieldDateStart,
          isGreaterThan: DateTime.now().toString(),
        )
        // .orderBy(SurveyCollection.fieldDateStart)
        .where(SurveyCollection.fieldStatus,
            isEqualTo: SurveyStatus.public.value)
        .limit(pageSize)
        .get();
    for (var doc in value.docs) {
      var data = doc.data();
      data[SurveyCollection.fieldSurveyId] = doc.id;
      var survey = Survey.fromMap(data);
      survey.outlet = Outlet(
        address: data[SurveyCollection.fieldAddress],
        latitude: data[SurveyCollection.fieldLatitude],
        longitude: data[SurveyCollection.fieldLongitude],
      );
      list.add(survey);
    }

    return list;
  }

  @override
  Future<List<Survey>> fetchMoreExploreSurvey({
    required Survey lastSurvey,
  }) async {
    List<Survey> list = [];

    var lastDoc = await ref.doc(lastSurvey.surveyId).get();
    var value = await ref
        .where(SurveyCollection.fieldStatus,
            isEqualTo: SurveyStatus.public.value)
        .orderBy(SurveyCollection.fieldDateCreate, descending: true)
        .startAfterDocument(lastDoc)
        .limit(pageSize)
        .get();
    for (var doc in value.docs) {
      var data = doc.data();

      if (data[SurveyCollection.fieldStatus] == SurveyStatus.archived.value) {
        continue;
      }

      data[SurveyCollection.fieldSurveyId] = doc.id;
      var survey = Survey.fromMap(data);
      survey.outlet = Outlet(
        address: data[SurveyCollection.fieldAddress],
        latitude: data[SurveyCollection.fieldLatitude],
        longitude: data[SurveyCollection.fieldLongitude],
      );
      list.add(survey);
    }

    return list;
  }

  Future<List<Survey>> fetchUserDoingSurvey(String userId) async {
    List<Survey> list = [];
    var doSurveyRepo = DoSurveyRepositoryImpl();
    var surveyIdList = await doSurveyRepo.fetchUserDoingSurveyId(userId);
    for (var surveyId in surveyIdList) {
      var survey = await fetchSurveyById(surveyId);
      if (survey != null) {
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
}
