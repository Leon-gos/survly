import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/dashboard/logic/survey_list_state.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/network/model/survey/survey.dart';

class SurveyListBloc extends Cubit<SurveyListState> {
  SurveyListBloc() : super(SurveyListState.ds()) {
    fetchAllSurvey();
  }

  DomainManager domainManager = DomainManager();

  void onSurveyListChange(List<Survey> list) {
    emit(state.copyWith(surveyList: list));
  }

  void onMySurveyListChange(List<Survey> list) {
    emit(state.copyWith(mySurveyList: list));
  }

  Future<void> fetchAllSurvey() async {
    var surveyList = await domainManager.survey.fetchAllSurvey();
    onSurveyListChange(surveyList);
    filterMySurvey();
  }

  void filterMySurvey() {
    List<Survey> mySurveyList = [];
    for (var survey in state.surveyList) {
      if (survey.adminId == AdminSingleton.instance().admin?.id) {
        mySurveyList.add(survey);
      }
    }
    onMySurveyListChange(mySurveyList);
  }

  void filterSurveyList(bool isShowMySurvey) {
    emit(state.copyWith(isShowMySurvey: isShowMySurvey));
  }
}
