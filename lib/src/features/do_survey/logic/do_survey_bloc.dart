import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/do_survey/logic/do_survey_state.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/network/data/do_survey/do_survey_repository_impl.dart';
import 'package:survly/src/network/data/location_log/location_log_repository_impl.dart';
import 'package:survly/src/network/model/location_log/location_log.dart';
import 'package:survly/src/network/model/question/question.dart';
import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/src/router/coordinator.dart';

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

    // test
    List<Set<String>> answerList = [];
    for (int i = 0; i < questionList.length; i++) {
      answerList.add(
          questionList[i].questionType == QuestionType.text.value ? {""} : {});
    }

    emit(state.copyWith(
      questionList: questionList,
      answerList: answerList,
    ));
  }

  void goNextPage() {
    if (state.currentPage < state.questionList.length) {
      emit(state.copyWith(currentPage: state.currentPage + 1));
      // Logger().d(state.currentPage);
    }
  }

  void goPreviousPage() {
    if (state.currentPage > 0) {
      emit(state.copyWith(currentPage: state.currentPage - 1));
      // Logger().d(state.currentPage);
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
}
