import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/src/features/preview_survey/logic/preview_survey_state.dart';
import 'package:survly/src/network/model/survey/survey.dart';

class PreviewSurveyBloc extends Cubit<PreviewSurveyState> {
  PreviewSurveyBloc(Survey survey)
      : super(PreviewSurveyState.ds(survey: survey)) {
    checkRequestStatus();
  }

  void checkRequestStatus() {}

  void requestSurvey() {
    emit(
      state.copyWith(
        hasRequested: !state.hasRequested,
      ),
    );
  }
}
