import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/admin_profile/logic/admin_profile_state.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/model/survey/survey.dart';

class AdminProfileBloc extends Cubit<AdminProfileState> {
  AdminProfileBloc() : super(AdminProfileState.ds()) {
    fetchAdminSurveyList();
  }

  DomainManager get domainManager => DomainManager();

  Future<void> fetchAdminSurveyList() async {
    var list = await domainManager.survey.fetchAdminSurveyList(
      UserBaseSingleton.instance().userBase?.id,
    );
    emit(state.copyWith(adminSurveyList: list));
  }

  void isShowProfileChange() {
    emit(state.copyWith(isShowProfile: !state.isShowProfile));
  }

  void archiveSurvey(Survey survey) {
    try {
      List<Survey> newList = List.from(state.adminSurveyList);
      newList.removeAt(state.adminSurveyList.indexOf(survey));
      emit(state.copyWith(adminSurveyList: newList));
    } catch (e) {
      Fluttertoast.showToast(msg: S.text.errorGeneral);
    }
  }

  void onSurveyListItemChange(Survey oldSurvey, Survey newSurvey) {
    try {
      List<Survey> newList = List.from(state.adminSurveyList);
      newList[state.adminSurveyList.indexOf(oldSurvey)] = newSurvey;
      emit(state.copyWith(adminSurveyList: newList));
    } catch (e) {
      Logger().e(S.text.errorGeneral, error: e);
      Fluttertoast.showToast(msg: S.text.errorGeneral);
    }
  }
}
