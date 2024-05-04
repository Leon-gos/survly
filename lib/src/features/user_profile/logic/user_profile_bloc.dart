import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/user_profile/logic/user_profile_state.dart';
import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/src/network/model/user/user.dart';

class UserProfileBloc extends Cubit<UserProfileState> {
  UserProfileBloc(User user) : super(UserProfileState.ds(user)) {
    fetchJoinedSurvey();
  }

  DomainManager get domainManager => DomainManager();

  void isShowProfileChange() {
    emit(
      state.copyWith(isShowProfile: !state.isShowProfile),
    );
  }

  Future<void> fetchJoinedSurvey() async {
    try {
      var doSurveyList =
          await domainManager.doSurvey.fetchUserJoinedSurvey(state.user.id);
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
}
