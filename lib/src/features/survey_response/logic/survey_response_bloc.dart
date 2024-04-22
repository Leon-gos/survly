import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/survey_response/logic/survey_response_state.dart';
import 'package:survly/src/network/model/survey/survey.dart';

class SurveyResponseBloc extends Cubit<SurveyResponseState> {
  SurveyResponseBloc(Survey survey) : super(SurveyResponseState.ds(survey)) {
    fetchResponseList(survey.surveyId);
  }

  DomainManager get domainManager => DomainManager();

  Future<void> fetchResponseList(String? surveyId) async {
    if (surveyId == null) {
      return;
    }
    var list = await domainManager.doSurvey.fetchDoSurveyList(surveyId);
    emit(state.copyWith(surveyResponseList: list));
    emit(state.copyWith(isLoading: false));
  }
}
