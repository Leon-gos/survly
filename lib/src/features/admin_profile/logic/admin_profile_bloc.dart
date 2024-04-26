import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/admin_profile/logic/admin_profile_state.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
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
    List<Survey> newList = List.from(state.adminSurveyList);
    newList.addAll(list);
    emit(state.copyWith(adminSurveyList: newList));
  }

  void isShowProfileChange() {
    emit(state.copyWith(isShowProfile: !state.isShowProfile));
  }
}
