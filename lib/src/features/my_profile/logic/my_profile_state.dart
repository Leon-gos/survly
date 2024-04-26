import 'package:equatable/equatable.dart';
import 'package:survly/src/network/model/do_survey/do_survey.dart';

import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/src/network/model/user/user.dart';

class MyProfileState extends Equatable {
  final List<Survey> joinedSurveyList;
  final List<DoSurvey> doSurveyList;
  final bool isShowProfile;

  const MyProfileState({
    required this.joinedSurveyList,
    required this.doSurveyList,
    required this.isShowProfile,
  });

  factory MyProfileState.ds(User user) => const MyProfileState(
        joinedSurveyList: [],
        doSurveyList: [],
        isShowProfile: true,
      );

  @override
  List<Object?> get props => [
        joinedSurveyList,
        doSurveyList,
        isShowProfile,
      ];

  MyProfileState copyWith({
    List<Survey>? joinedSurveyList,
    List<DoSurvey>? doSurveyList,
    bool? isShowProfile,
  }) {
    return MyProfileState(
      joinedSurveyList: joinedSurveyList ?? this.joinedSurveyList,
      doSurveyList: doSurveyList ?? this.doSurveyList,
      isShowProfile: isShowProfile ?? this.isShowProfile,
    );
  }
}
