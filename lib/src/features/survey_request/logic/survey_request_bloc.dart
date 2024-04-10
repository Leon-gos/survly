import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/survey_request/logic/survey_request_state.dart';

class SurveyRequestBloc extends Cubit<SurveyRequestState> {
  SurveyRequestBloc(String? surveyId) : super(SurveyRequestState.ds()) {
    fetchRequestList(surveyId);
  }

  DomainManager get domainManager => DomainManager();

  Future<void> fetchRequestList(String? surveyId) async {
    if (surveyId == null) {
      return;
    }
    var list = await domainManager.surveyRequest.fetchSurveyRequest(surveyId);
    Logger().d(list.length);
    emit(state.copyWith(surveyRequestList: list));
  }
}
