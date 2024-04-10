import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/review_survey/logic/review_survey_state.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/model/survey/survey.dart';

class ReviewSurveyBloc extends Cubit<ReviewSurveyState> {
  ReviewSurveyBloc(Survey survey)
      : super(ReviewSurveyState.ds(survey: survey)) {
    fetchSurveyQuestionList();
  }

  DomainManager get domainManager => DomainManager();

  Future<Survey?> onRefresh() async {
    try {
      emit(
        state.copyWith(
          survey:
              await domainManager.survey.fetchSurveyById(state.survey.surveyId),
        ),
      );
      fetchSurveyQuestionList();
      return state.survey;
    } catch (e) {
      Fluttertoast.showToast(msg: S.text.errorGeneral);
    }
    return null;
  }

  Future<void> fetchSurveyQuestionList() async {
    emit(
      state.copyWith(
        questionList: await domainManager.question
            .fetchAllQuestionOfSurvey(state.survey.surveyId),
      ),
    );
  }

  void publishSurvey() {
    emit(
      state.copyWith(
        survey: state.survey.copyWith(status: SurveyStatus.public.value),
      ),
    );
    Fluttertoast.showToast(msg: "Change status successfully");

    // if (surveyInfoValid() && questionListValid()) {
    //   emit(
    //     state.copyWith(
    //       survey: state.survey.copyWith(status: SurveyStatus.public.value),
    //     ),
    //   );
    //   Fluttertoast.showToast(msg: "Change status successfully");
    // } else {
    //   Fluttertoast.showToast(msg: "Change status failed");
    // }
  }

  void draftSurvey() {
    emit(
      state.copyWith(
        survey: state.survey.copyWith(status: SurveyStatus.draft.value),
      ),
    );
    Fluttertoast.showToast(msg: "Change status successfully");
  }

  // bool surveyInfoValid() {
  //   var error = state.survey.getError();
  //   if (error != null) {
  //     Fluttertoast.showToast(msg: error);
  //     return false;
  //   }
  //   return true;
  // }

  // bool questionListValid() {
  //   if (state.questionList.isEmpty) {
  //     Fluttertoast.showToast(msg: "Question list empty");
  //     return false;
  //   }
  //   for (var question in state.questionList) {
  //     if (question.getError() != null) {
  //       Fluttertoast.showToast(msg: question.getError()!);
  //       return false;
  //     }
  //   }
  //   return true;
  // }
}
