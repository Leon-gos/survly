import 'package:equatable/equatable.dart';

import 'package:survly/src/network/model/do_survey/do_survey.dart';
import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/src/network/model/user/user.dart';

class UserProfileState extends Equatable {
  final User user;
  final List<Survey> joinedSurveyList;
  final List<DoSurvey> doSurveyList;
  final bool isShowProfile;

  const UserProfileState({
    required this.user,
    required this.joinedSurveyList,
    required this.doSurveyList,
    required this.isShowProfile,
  });

  factory UserProfileState.ds(User user) => UserProfileState(
      user: user,
      joinedSurveyList: const [],
      doSurveyList: const [],
      isShowProfile: true);

  // List<Survey> get doingSurveyList {
  //   List<Survey> list = [];

  //   for (var survey in joinedSurveyList) {
  //     if ()
  //   }

  //   return list;
  // }

  @override
  List<Object?> get props => [
        user,
        joinedSurveyList,
        doSurveyList,
        isShowProfile,
      ];

  UserProfileState copyWith({
    User? user,
    List<Survey>? joinedSurveyList,
    List<DoSurvey>? doSurveyList,
    bool? isShowProfile,
  }) {
    return UserProfileState(
      user: user ?? this.user,
      joinedSurveyList: joinedSurveyList ?? this.joinedSurveyList,
      doSurveyList: doSurveyList ?? this.doSurveyList,
      isShowProfile: isShowProfile ?? this.isShowProfile,
    );
  }
}
