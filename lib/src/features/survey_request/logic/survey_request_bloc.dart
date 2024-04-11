import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/survey_request/logic/survey_request_state.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/src/network/model/survey_request/survey_request.dart';

class SurveyRequestBloc extends Cubit<SurveyRequestState> {
  SurveyRequestBloc(Survey survey) : super(SurveyRequestState.ds(survey)) {
    fetchRequestList(survey.surveyId);
  }

  DomainManager get domainManager => DomainManager();

  Future<void> fetchRequestList(String? surveyId) async {
    if (surveyId == null) {
      return;
    }
    var list = await domainManager.surveyRequest.fetchRequestOfSurvey(surveyId);
    emit(state.copyWith(surveyRequestList: list));
    emit(state.copyWith(isLoading: false));
  }

  Future<void> reponseRequest(
      SurveyRequest request, SurveyRequestStatus status) async {
    emit(state.copyWith(isLoading: true));
    try {
      await domainManager.surveyRequest.responseSurveyRequest(
        requestId: request.requestId,
        status: status,
      );
      List<SurveyRequest> newList = List.of(state.surveyRequestList);
      newList[state.surveyRequestList.indexOf(request)] =
          request.copyWith(status: status.value);
      emit(state.copyWith(surveyRequestList: newList));
      Fluttertoast.showToast(msg: S.text.toastResponseSurveySuccess);
    } catch (e) {
      Fluttertoast.showToast(msg: S.text.toastResponseSurveyFail);
      Logger().e("Something went wrong", error: e);
    }
    emit(state.copyWith(isLoading: false));
  }
}
