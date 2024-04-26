import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/my_profile/logic/my_profile_state.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/src/network/model/user/user.dart';

class MyProfileBloc extends Cubit<MyProfileState> {
  MyProfileBloc()
      : super(
          MyProfileState.ds(UserBaseSingleton.instance().userBase as User),
        ) {
    fetchJoinedSurvey();
  }

  DomainManager get domainManager => DomainManager();

  Future<void> fetchJoinedSurvey() async {
    try {
      var doSurveyList = await domainManager.doSurvey
          .fetchUserJoinedSurvey(UserBaseSingleton.instance().userBase!.id);
      List<Survey> joinedSurveyList = [];
      for (var doSurvey in doSurveyList) {
        var survey =
            await domainManager.survey.fetchSurveyById(doSurvey.surveyId);
        if (survey != null) {
          joinedSurveyList.add(survey);
        }
      }
      emit(state.copyWith(
        joinedSurveyList: joinedSurveyList,
        doSurveyList: doSurveyList,
      ));
    } catch (e) {
      Logger().e("Failed to fetch user doing surveys", error: e);
    }
  }

  void isShowProfileChange() {
    emit(state.copyWith(isShowProfile: !state.isShowProfile));
  }
}
