import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/dashboard_user/logic/doing_survey_list_state.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';

class DoingSurveyListBloc extends Cubit<DoingSurveyListState> {
  DoingSurveyListBloc() : super(DoingSurveyListState.ds()) {
    fetchAllDoingSurvey();
  }

  DomainManager get domainManager => DomainManager();

  Future<void> fetchAllDoingSurvey() async {
    emit(state.copyWith(surveyList: []));
    try {
      var surveyList = await domainManager.survey.fetchUserDoingSurvey(
        UserBaseSingleton.instance().userBase!.id,
      );
      emit(state.copyWith(surveyList: surveyList, isLoading: false));
    } catch (e) {
      Logger().e("Failed to fetch user doing surveys", error: e);
      emit(
        state.copyWith(isLoading: false),
      );
    }
  }
}
