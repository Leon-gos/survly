import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
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

  Future<void> publishSurvey() async {
    try {
      await domainManager.survey.changeSurveyStatus(
        state.survey.surveyId,
        SurveyStatus.public.value,
      );
      emit(
        state.copyWith(
          survey: state.survey.copyWith(status: SurveyStatus.public.value),
        ),
      );
      Fluttertoast.showToast(msg: S.text.toastPublishSurveySuccess);
    } catch (e) {
      Logger().e("Publish error", error: e);
      Fluttertoast.showToast(msg: S.text.errorGeneral);
      Fluttertoast.showToast(msg: S.text.toastPublishSurveyFail);
    }
  }

  Future<void> draftSurvey() async {
    try {
      await domainManager.survey.changeSurveyStatus(
        state.survey.surveyId,
        SurveyStatus.draft.value,
      );
      emit(
        state.copyWith(
          survey: state.survey.copyWith(status: SurveyStatus.draft.value),
        ),
      );
      Fluttertoast.showToast(msg: S.text.toastDraftSurveySuccess);
    } catch (e) {
      Logger().e("Draft error", error: e);
      Fluttertoast.showToast(msg: S.text.errorGeneral);
      Fluttertoast.showToast(msg: S.text.toastDraftSurveyFail);
    }
  }
}
