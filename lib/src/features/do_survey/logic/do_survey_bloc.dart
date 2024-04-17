import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/do_survey/logic/do_survey_state.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/network/data/do_survey/do_survey_repository_impl.dart';
import 'package:survly/src/network/data/location_log/location_log_repository_impl.dart';
import 'package:survly/src/network/model/location_log/location_log.dart';
import 'package:survly/src/network/model/question/question.dart';
import 'package:survly/src/network/model/question/question_with_options.dart';
import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/src/router/coordinator.dart';
import 'package:survly/widgets/app_dialog.dart';

class DoSurveyBloc extends Cubit<DoSurveyState> {
  Timer? timer;

  DoSurveyBloc(Survey survey) : super(DoSurveyState.ds(survey: survey)) {
    fetchDoSurveyInfo(survey);
    fetchQuestionList(survey);
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

  void goNextPage(BuildContext context) {
    if (state.currentPage < state.questionList.length) {
      emit(state.copyWith(currentPage: state.currentPage + 1));
    } else {
      //TODO: submit survey
    }
  }

  void goPreviousPage(BuildContext context) {
    if (state.currentPage > 0) {
      emit(state.copyWith(currentPage: state.currentPage - 1));
    } else {
      showDialog(
        context: context,
        builder: (dialogContext) {
          return AppDialog(
            title: "Exit without save",
            body: "Your recent changes will not be saved",
            onCancelPressed: () {},
            onConfirmPressed: () {
              context.pop();
            },
          );
        },
      );
    }
  }

  void onAnswer(int questionPosition, String answer) {
    List<Set<String>> list = List.from(state.answerList);
    if (state.questionList[questionPosition].questionType ==
        QuestionType.multiOption.value) {
      list[questionPosition].add(answer);
    } else {
      list[questionPosition] = {answer};
    }
    emit(state.copyWith(answerList: list));
    Logger().d(state.answerList);
  }

  Future<void> saveDraft() async {
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
    Fluttertoast.showToast(msg: "Save draft survey successfully");
  }

  void onSaveDraftSurveyBtnPressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AppDialog(
          title: "Save draft survey",
          body:
              "Save your survey as draft, you can edit it continuously next time",
          option2Text: "Save and exit",
          onOption2Pressed: () async {
            await saveDraft().then((value) {
              context.pop();
            });
          },
          option1Text: "Save",
          onOption1Pressed: () {
            saveDraft();
          },
        );
      },
    );
  }
}
