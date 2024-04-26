import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/my_profile/logic/my_profile_state.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/network/model/user/user.dart';

class MyProfileBloc extends Cubit<MyProfileState> {
  MyProfileBloc()
      : super(
          MyProfileState.ds(UserBaseSingleton.instance().userBase as User),
        ) {
    fetchAllDoingSurvey();
  }

  DomainManager get domainManager => DomainManager();

  Future<void> fetchAllDoingSurvey() async {
    try {
      var surveyList = await domainManager.survey.fetchUserDoingSurvey(
        UserBaseSingleton.instance().userBase!.id,
      );
      emit(state.copyWith(mySurveyList: surveyList));
    } catch (e) {
      Logger().e("Failed to fetch user doing surveys", error: e);
    }
  }

  void isShowProfileChange() {
    emit(state.copyWith(isShowProfile: !state.isShowProfile));
  }
}
