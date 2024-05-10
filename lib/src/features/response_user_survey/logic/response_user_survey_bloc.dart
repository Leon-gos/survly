import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/config/constants/notification.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/response_user_survey/logic/response_user_survey_state.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/model/do_survey/do_survey.dart';
import 'package:survly/src/network/model/notification/noti_do_survey.dart';
import 'package:survly/src/service/notification/model/noti_request_body.dart';
import 'package:survly/src/service/notification/model/noti_request_body.dart'
    as my_noti;
import 'package:survly/src/network/model/question/question.dart';
import 'package:survly/src/network/model/question/question_with_options.dart';
import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/src/router/coordinator.dart';
import 'package:survly/src/service/notification/service/notification_service.dart';

class ResponseUserSurveyBloc extends Cubit<ResponseUserSurveyState> {
  ResponseUserSurveyBloc(String surveyId, String doSurveyId)
      : super(ResponseUserSurveyState.ds()) {
    fetchData(surveyId, doSurveyId);
  }

  DomainManager get domainManager => DomainManager();

  Future<void> fetchData(String surveyId, String doSurveyId) async {
    var survey = await domainManager.survey.fetchSurveyById(surveyId);
    var doSurvey = await domainManager.doSurvey.fetchDoSurveyById(doSurveyId);
    doSurvey?.user = await domainManager.user.fetchUserById(doSurvey.userId);
    if (survey != null && doSurvey != null) {
      emit(state.copyWith(survey: survey, doSurvey: doSurvey));
      fetchQuestionList(survey, doSurvey);
    } else {
      Fluttertoast.showToast(msg: S.text.errorGeneral);
      AppCoordinator.pop();
    }
  }

  Future<void> fetchQuestionList(Survey survey, DoSurvey doSurvey) async {
    var questionList = await domainManager.question.fetchAllQuestionOfSurvey(
      state.survey!.surveyId,
    );

    List<Set<String>> answerList = [];
    for (var question in questionList) {
      if (question.questionType == QuestionType.text.value) {
        answerList.add(
          {
            await domainManager.answerQuestion.fetchQuestionAnswer(
                  questionId: question.questionId,
                  userId: doSurvey.userId,
                ) ??
                ""
          },
        );
      } else {
        Set<String> answerSet = {};
        for (var option in (question as QuestionWithOption).optionList) {
          if (await domainManager.answerOption.isOptionChecked(
              optionId: option.questionOptionId, userId: doSurvey.userId)) {
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
    if (state.currentPage <= state.questionList.length) {
      emit(state.copyWith(currentPage: state.currentPage + 1));
      return;
    }
  }

  void goPreviousPage(BuildContext context) {
    if (state.currentPage > 0) {
      emit(state.copyWith(currentPage: state.currentPage - 1));
    } else {
      context.pop();
    }
  }

  Future<void> ignoreSurvey() async {
    try {
      await domainManager.doSurvey.updateDoSurveyStatus(
        state.doSurvey!.doSurveyId,
        DoSurveyStatus.ignored,
      );

      sendNoti(
        notiTitle: S.text.notiTitleSurveyIgnore,
        notiBody: S.text.notiBodySurveyIgnore,
        notiType: NotiType.adminResponseSurvey.value,
        fromUserId: UserBaseSingleton.instance().userBase!.id,
        toUserId: state.doSurvey!.user!.id,
        doSurvey: state.doSurvey!,
      );

      Fluttertoast.showToast(msg: S.text.toastIgnoreSurveySuccessful);
      AppCoordinator.pop(true);
    } catch (e) {
      Fluttertoast.showToast(msg: S.text.toastIgnoreSurveyFail);
      Logger().e("Ignore survey error", error: e);
    }
  }

  Future<void> approveSurvey() async {
    try {
      await domainManager.doSurvey.updateDoSurveyStatus(
        state.doSurvey!.doSurveyId,
        DoSurveyStatus.approved,
      );
      // update user balance
      domainManager.user
          .updateUserBalance(state.doSurvey!.userId, state.survey!.cost);

      // update respondent num
      domainManager.survey.increaseSurveyRespondentNum(state.survey!.surveyId);

      // send noti
      sendNoti(
        notiTitle: S.text.notiTitleSurveyApprove,
        notiBody: S.text.notiBodySurveyApprove,
        notiType: NotiType.adminResponseSurvey.value,
        fromUserId: UserBaseSingleton.instance().userBase!.id,
        toUserId: state.doSurvey!.user!.id,
        doSurvey: state.doSurvey!,
      );

      Fluttertoast.showToast(msg: S.text.toastApproveSurveySuccessfully);
      AppCoordinator.pop(true);
    } catch (e) {
      Fluttertoast.showToast(msg: S.text.toastApproveSurveyFail);
      Logger().e("Approve survey error", error: e);
    }
  }

  void sendNoti({
    required String notiTitle,
    required String notiBody,
    required String notiType,
    required String fromUserId,
    required String toUserId,
    required DoSurvey doSurvey,
  }) {
    try {
      NotificationService.sendNotiToUserById(
        requestBody: NotiRequestBody(
          notification: my_noti.Notification(
            title: notiTitle,
            body: notiBody,
          ),
          data: {
            NotiDataField.type: notiType,
          },
        ),
        userId: toUserId,
      );

      domainManager.notification.createNoti(
        NotiDoSurvey.init(
          title: notiTitle,
          body: notiBody,
          type: notiType,
          fromUserId: fromUserId,
          toUserId: toUserId,
          doSurveyId: doSurvey.doSurveyId,
        ),
      );
    } catch (e) {
      Logger().e("send noti error", error: e);
    }
  }
}
