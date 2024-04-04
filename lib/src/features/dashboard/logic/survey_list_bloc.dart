import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/dashboard/logic/survey_list_state.dart';
import 'package:survly/src/network/model/survey/survey.dart';

class SurveyListBloc extends Cubit<SurveyListState> {
  SurveyListBloc() : super(SurveyListState.ds()) {
    fetchFirstPageSurvey();
  }

  DomainManager domainManager = DomainManager();

  void onSurveyListChange(List<Survey> list) {
    List<Survey> newList = List.from(state.surveyList);
    newList.addAll(list);
    emit(state.copyWith(surveyList: newList, isLoading: false));
  }

  Future<void> fetchFirstPageSurvey() async {
    emit(state.copyWith(surveyList: []));
    var surveyList = await domainManager.survey.fetchFirstPageSurvey();
    onSurveyListChange(surveyList);
  }

  Future<void> fetchMoreSurvey() async {
    if (state.surveyList.length - 1 >= 0) {
      List<Survey> surveyList = await domainManager.survey.fetchMoreSurvey(
          lastSurvey: state.surveyList[state.surveyList.length - 1]);
      Logger().d(surveyList.length);
      onSurveyListChange(surveyList);
    }
  }

  void filterSurveyList(bool isShowMySurvey) {
    emit(state.copyWith(isShowMySurvey: isShowMySurvey));
  }
}
