import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:image_editor/image_editor.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/config/constants/notification.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/do_survey/logic/do_survey_state.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/data/do_survey/do_survey_repository_impl.dart';
import 'package:survly/src/network/data/location_log/location_log_repository_impl.dart';
import 'package:survly/src/network/model/location_log/location_log.dart';
import 'package:survly/src/network/model/notification/message_data.dart';
import 'package:survly/src/network/model/question/question.dart';
import 'package:survly/src/network/model/question/question_with_options.dart';
import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/src/router/coordinator.dart';
import 'package:survly/src/service/notification_service.dart';
import 'package:survly/src/service/picker_service.dart';
import 'package:survly/src/utils/coordinate_helper.dart';
import 'package:survly/widgets/app_dialog.dart';

class DoSurveyBloc extends Cubit<DoSurveyState> {
  Timer? timer;
  static const minKmToSubmit = 10;

  DoSurveyBloc(Survey survey) : super(DoSurveyState.ds(survey: survey)) {
    fetchDoSurveyInfo(survey);
    fetchQuestionList(survey);
    fetchAdminFcmToken(survey);
    setupTimer();
  }

  DomainManager get domainManager => DomainManager();

  Future<void> fetchDoSurveyInfo(Survey survey) async {
    var doSurvey = await domainManager.doSurvey.fetchDoSurveyBySurveyAndUser(
      surveyId: state.survey.surveyId,
      userId: UserBaseSingleton.instance().userBase!.id,
    );
    if (doSurvey != null) {
      emit(state.copyWith(doSurvey: doSurvey));
    } else {
      AppCoordinator.pop();
    }
  }

  void setupTimer() {
    timer = Timer.periodic(
      DoSurveyState.updateDuration,
      (timer) async {
        var event = await state.location.getLocation();

        var newDs = state.doSurvey!.copyWith(
          currentLat: event.latitude,
          currentLng: event.longitude,
        );

        emit(state.copyWith(doSurvey: newDs));

        DoSurveyRepositoryImpl().updateCurrentLocation(newDs);
        try {
          LocationLogRepositoryImpl().addLocationLog(
            LocationLog(
              doSurveyId: newDs.doSurveyId,
              dateCreate: DateTime.now().toString(),
              latitude: event.latitude!,
              longitude: event.longitude!,
            ),
          );
        } catch (e) {
          Logger().e("add location log failed", error: e);
        }
      },
    );
  }

  @override
  Future<void> close() {
    timer?.cancel();
    return super.close();
  }

  Future<void> fetchQuestionList(Survey survey) async {
    var questionList = await domainManager.question.fetchAllQuestionOfSurvey(
      state.survey.surveyId,
    );

    List<Set<String>> answerList = [];
    for (var question in questionList) {
      if (question.questionType == QuestionType.text.value) {
        answerList.add(
          {
            await domainManager.answerQuestion.fetchQuestionAnswer(
                  questionId: question.questionId,
                  userId: UserBaseSingleton.instance().userBase!.id,
                ) ??
                ""
          },
        );
      } else {
        Set<String> answerSet = {};
        for (var option in (question as QuestionWithOption).optionList) {
          if (await domainManager.answerOption.isOptionChecked(
              optionId: option.questionOptionId,
              userId: UserBaseSingleton.instance().userBase!.id)) {
            answerSet.add(option.questionOptionId);
          }
        }
        answerList.add(answerSet);
      }
    }

    emit(state.copyWith(
      questionList: questionList,
      answerList: answerList,
    ));
  }

  Future<void> goNextPage(BuildContext context) async {
    // go to next page
    if (state.currentPage <= state.questionList.length) {
      emit(state.copyWith(currentPage: state.currentPage + 1));
      return;
    }

    // check is all questions are answered
    int pageNotComplete = state.pageNotComplete();
    if (pageNotComplete >= 0) {
      Fluttertoast.showToast(msg: S.text.toastMustAnswerAllQuestion);
      emit(state.copyWith(currentPage: pageNotComplete));
      return;
    }

    // check if current location near outlet place
    await state.location.getLocation().then(
      (currentLocation) {
        final distanceToOutlet = CoordinateHelper.getDistanceFromLatLngInKm(
          lat1: currentLocation.latitude,
          lng1: currentLocation.longitude,
          lat2: state.survey.outlet?.latitude,
          lng2: state.survey.outlet?.longitude,
        );

        if (distanceToOutlet == null || distanceToOutlet > minKmToSubmit) {
          Fluttertoast.showToast(msg: S.text.toastMustStayNearOutletPlace);
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AppDialog(
                title: S.text.dialogTitleSubmitSurvey,
                body: S.text.dialogBodySubmitSurvey,
                onConfirmPressed: () {
                  submitSurvey();
                },
              );
            },
          );
        }
      },
    );
  }

  void goPreviousPage(BuildContext context) {
    if (state.currentPage > 0) {
      emit(state.copyWith(currentPage: state.currentPage - 1));
    } else {
      if (state.isSaved == false) {
        showDialog(
          context: context,
          builder: (dialogContext) {
            return AppDialog(
              title: S.text.dialogTitleExitWithoutSave,
              body: S.text.dialogBodyExitWithoutSave,
              onCancelPressed: () {},
              onConfirmPressed: () {
                context.pop();
              },
            );
          },
        );
      } else {
        context.pop();
      }
    }
  }

  void onAnswer(int questionPosition, String answer) {
    List<Set<String>> list = List.from(state.answerList);
    if (state.questionList[questionPosition].questionType ==
        QuestionType.multiOption.value) {
      if (list[questionPosition].contains(answer)) {
        list[questionPosition].remove(answer);
      } else {
        list[questionPosition].add(answer);
      }
    } else {
      list[questionPosition] = {answer};
    }
    emit(state.copyWith(
      answerList: list,
      isSaved: false,
    ));
    Logger().d(state.answerList);
  }

  Future<void> onTakeOutletPhoto() async {
    var value = await PickerService.takePhotoByCamera();
    if (value == null) {
      return;
    }
    final decodeImage = await decodeImageFromList(
      await value.readAsBytes(),
    );
    final imageWidth = decodeImage.width;
    final imageHeight = decodeImage.height;
    final fontSize = imageWidth ~/ 20;
    Logger().d("$imageWidth $imageHeight $fontSize");
    final textOption = AddTextOption();
    final location = await state.location.getLocation();
    textOption.addText(
      EditorText(
        offset: Offset(fontSize.toDouble(), imageHeight - fontSize * 2),
        text: "(${location.latitude}, ${location.longitude})",
        fontSizePx: fontSize,
        textColor: Colors.white,
        fontName: "",
      ),
    );
    final editor = ImageEditorOption();
    editor.addOption(textOption);
    var newFile = await ImageEditor.editFileImageAndGetFile(
      file: File(value.path),
      imageEditorOption: editor,
    );
    newFile = await newFile?.rename("${newFile.path}.png");

    emit(state.copyWith(
      outletPath: newFile?.path,
      isSaved: false,
    ));
  }

  Future<void> saveDraft() async {
    // save answers
    for (int i = 0; i < state.questionList.length; i++) {
      var question = state.questionList[i];
      var answer = state.answerList[i];
      if (question.questionType == QuestionType.text.value) {
        await domainManager.answerQuestion.answerQuestion(
          questionId: question.questionId,
          userId: UserBaseSingleton.instance().userBase!.id,
          answer: answer.firstOrNull ?? "",
        );
      } else {
        question = question as QuestionWithOption;
        await domainManager.answerOption.answerOption(
          optionList: question.optionList,
          optionIdCheckedList: answer,
          userId: UserBaseSingleton.instance().userBase!.id,
        );
      }
    }

    // update do survey
    try {
      var doSurvey = state.doSurvey;
      doSurvey?.dateUpdate = DateTime.now().toString();
      await domainManager.doSurvey.updateDoSurvey(
        state.doSurvey!,
        state.outletPath,
      );
      emit(state.copyWith(doSurvey: doSurvey, isSaved: true));
    } catch (e) {
      Logger().e("Update outlet error", error: e);
    }
  }

  void onSaveDraftSurveyBtnPressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AppDialog(
          title: S.text.dialogTitleSaveDraft,
          body: S.text.dialogBodySaveDraft,
          option2Text: S.text.labelBtnSaveAndExit,
          onOption2Pressed: () async {
            await saveDraft().then((value) {
              context.pop();
            });
          },
          option1Text: S.text.labelBtnSave,
          onOption1Pressed: () async {
            await saveDraft();
            Fluttertoast.showToast(msg: S.text.toastSaveDraftSurveySuccess);
          },
        );
      },
    );
  }

  Future<void> submitSurvey() async {
    try {
      await saveDraft();
      var doSurvey = state.doSurvey;
      await domainManager.doSurvey.submitDoSurvey(doSurvey!);

      // send noti to admin device
      var data = MessageData(
        data: List<String>.of([state.survey.surveyId, doSurvey.doSurveyId]),
        type: NotiType.userResponseSurvey.value,
      );
      NotificationService.sendNotiToOneDevice(
        notiTitle: "New respondent",
        notiBody: "Someone has just response your survey. Check now!",
        fcmToken: state.adminFcmToken,
        data: data,
      );

      Fluttertoast.showToast(msg: S.text.toastSubmitSurveySuccess);
      AppCoordinator.pop();
    } catch (e) {
      Fluttertoast.showToast(msg: S.text.toastSubmitSurveyFail);
      Logger().e("Submit survey failed", error: e);
    }
  }

  Future<void> fetchAdminFcmToken(Survey survey) async {
    String? fcmToken =
        await domainManager.user.fetchUserFcmToken(survey.adminId);
    emit(state.copyWith(adminFcmToken: fcmToken));
  }
}
