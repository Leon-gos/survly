import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/dashboard_admin/logic/survey_list_state.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/model/survey/survey.dart';

class SurveyListBloc extends Cubit<SurveyListState> {
  SurveyListBloc() : super(SurveyListState.ds()) {
    fetchFirstPageSurvey();
  }

  DomainManager domainManager = DomainManager();

  void concatSurveyList(List<Survey> list) {
    List<Survey> newList = List.from(state.surveyList);
    newList.addAll(list);
    emit(state.copyWith(surveyList: newList, isLoading: false));
  }

  Future<void> fetchFirstPageSurvey() async {
    emit(state.copyWith(surveyList: []));
    try {
      var surveyList = await domainManager.survey.fetchFirstPageSurvey();
      concatSurveyList(surveyList);
    } catch (e) {
      Logger().e("Failed to fetch first page of surveys", error: e);
      emit(
        state.copyWith(isLoading: false),
      );
    }
  }

  Future<void> fetchMoreSurvey() async {
    if (state.surveyList.length - 1 >= 0) {
      try {
        List<Survey> surveyList = await domainManager.survey.fetchMoreSurvey(
            lastSurvey: state.surveyList[state.surveyList.length - 1]);
        Logger().d(surveyList.length);
        concatSurveyList(surveyList);
      } catch (e) {
        Logger().e("Failed to fetch more surveys", error: e);
      }
    }
  }

  void filterSurveyList(bool isShowMySurvey) {
    emit(state.copyWith(isShowMySurvey: isShowMySurvey));
  }

  void onSurveyListItemChange(Survey oldSurvey, Survey newSurvey) {
    try {
      List<Survey> newList = List.from(state.surveyList);
      newList[state.surveyList.indexOf(oldSurvey)] = newSurvey;
      emit(state.copyWith(surveyList: newList));
    } catch (e) {
      Logger().e(S.text.errorGeneral, error: e);
    }
  }

  void archiveSurvey(Survey survey) {
    try {
      List<Survey> newList = List.from(state.surveyList);
      newList.removeAt(state.surveyList.indexOf(survey));
      emit(state.copyWith(surveyList: newList));
    } catch (e) {
      Logger().e(S.text.errorGeneral, error: e);
    }
  }
}
