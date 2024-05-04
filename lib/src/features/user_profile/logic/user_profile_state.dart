import 'package:equatable/equatable.dart';

import 'package:survly/src/network/model/do_survey/do_survey.dart';
import 'package:survly/src/network/model/user/user.dart';

class UserProfileState extends Equatable {
  final User user;
  final List<DoSurvey> doSurveyList;
  final bool isShowProfile;

  const UserProfileState({
    required this.user,
    required this.doSurveyList,
    required this.isShowProfile,
  });

  factory UserProfileState.ds(User user) =>
      UserProfileState(user: user, doSurveyList: const [], isShowProfile: true);

  List<DoSurvey> getDoSurveyListByStatus(DoSurveyStatus status) {
    List<DoSurvey> list = [];

    for (var doSurvey in doSurveyList) {
      if (doSurvey.status == status.value) {
        list.add(doSurvey);
      }
    }

    return list;
  }

  @override
  List<Object?> get props => [
        user,
        doSurveyList,
        isShowProfile,
      ];

  UserProfileState copyWith({
    User? user,
    List<DoSurvey>? doSurveyList,
    bool? isShowProfile,
  }) {
    return UserProfileState(
      user: user ?? this.user,
      doSurveyList: doSurveyList ?? this.doSurveyList,
      isShowProfile: isShowProfile ?? this.isShowProfile,
    );
  }
}
