import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:logger/web.dart';
import 'package:survly/src/config/constants/firebase_collections.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/network/data/file/file_data.dart';
import 'package:survly/src/network/data/survey/survey_repository.dart';
import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/src/network/model/user_base/user_base.dart';

class SurveyRepositoryImpl implements SurveyRepository {
  final ref =
      FirebaseFirestore.instance.collection(SurveyCollection.collectionName);

  static const int pageSize = 8;

  @override
  Future<List<Survey>> fetchFirstPageSurvey() async {
    List<Survey> list = [];

    var value =
        await ref.orderBy(SurveyCollection.fieldTitle).limit(pageSize).get();
    for (var doc in value.docs) {
      var data = doc.data();
      data[SurveyCollection.fieldSurveyId] = doc.id;
      list.add(Survey.fromMap(data));
    }

    return list;
  }

  @override
  Future<List<Survey>> fetchMoreSurvey({required Survey lastSurvey}) async {
    List<Survey> list = [];

    var lastDoc = await ref.doc(lastSurvey.surveyId).get();
    var value = await ref
        .orderBy(SurveyCollection.fieldTitle)
        .startAfterDocument(lastDoc)
        .limit(pageSize)
        .get();
    for (var doc in value.docs) {
      var data = doc.data();
      data[SurveyCollection.fieldSurveyId] = doc.id;
      list.add(Survey.fromMap(data));
    }

    return list;
  }

  @override
  Future<void> createSurvey({
    required Survey survey,
    required String fileLocalPath,
  }) async {
    try {
      // 1: insert survey
      survey.adminId = AdminSingleton.instance().admin!.id;
      await ref.add({}).then((value) {
        survey.surveyId = value.id;
        ref.doc("/${value.id}").set(survey.toMap());
      });

      if (fileLocalPath == "") {
        return;
      }

      // 2: upload image
      Logger().d(fileLocalPath);
      String? imageUrl = await FileData.instance().uploadFile(
          filePath: fileLocalPath,
          fileKey:
              "${UserBase.roleAdmin}/${SurveyCollection.collectionName}/${survey.surveyId}");

      // 3: update survey thumbnail
      ref.doc(survey.surveyId).update({
        SurveyCollection.fieldThumbnail: imageUrl,
      });
    } catch (e) {
      rethrow;
    }
  }
}
