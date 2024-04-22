import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/response_user_survey/logic/response_user_survey_state.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/model/do_survey/do_survey.dart';
import 'package:survly/src/network/model/question/question.dart';
import 'package:survly/src/network/model/question/question_with_options.dart';
import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/src/router/coordinator.dart';
import 'package:survly/widgets/app_dialog.dart';

class ResponseUserSurveyBloc extends Cubit<ResponseUserSurveyState> {
  ResponseUserSurveyBloc(Survey survey, DoSurvey doSurvey)
      : super(ResponseUserSurveyState.ds(survey: survey, doSurvey: doSurvey)) {
    fetchQuestionList(survey, doSurvey);
  }

  DomainManager get domainManager => DomainManager();

  Future<void> fetchQuestionList(Survey survey, DoSurvey doSurvey) async {
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
    // go to next page
    if (state.currentPage <= state.questionList.length) {
      emit(state.copyWith(currentPage: state.currentPage + 1));
      return;
    }
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

  Future<void> ignoreSurvey() async {
    try {
      await domainManager.doSurvey.updateDoSurveyStatus(
        state.doSurvey!.doSurveyId,
        DoSurveyStatus.ignored,
      );
      Fluttertoast.showToast(msg: "Ignore survey successfully");
      AppCoordinator.pop(true);
    } catch (e) {
      Fluttertoast.showToast(msg: "Ignore survey failed");
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
          .updateUserBalance(state.doSurvey!.userId, state.survey.cost);

      // update respondent num
      domainManager.survey.inscreaseSurveyRespondentNum(state.survey.surveyId);

      Fluttertoast.showToast(msg: "Approve survey successfully");
      AppCoordinator.pop(true);
    } catch (e) {
      Fluttertoast.showToast(msg: "Approve survey failed");
      Logger().e("Approve survey error", error: e);
    }
  }
}
