import 'package:equatable/equatable.dart';
import 'package:survly/src/network/model/do_survey/do_survey.dart';
import 'package:survly/src/network/model/user/user.dart';

class MyProfileState extends Equatable {
  final List<DoSurvey> doSurveyList;
  final bool isShowProfile;

  const MyProfileState({
    required this.doSurveyList,
    required this.isShowProfile,
  });

  factory MyProfileState.ds(User user) => const MyProfileState(
        doSurveyList: [],
        isShowProfile: true,
      );

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
        doSurveyList,
        isShowProfile,
      ];

  MyProfileState copyWith({
    List<DoSurvey>? doSurveyList,
    bool? isShowProfile,
  }) {
    return MyProfileState(
      doSurveyList: doSurveyList ?? this.doSurveyList,
      isShowProfile: isShowProfile ?? this.isShowProfile,
    );
  }
}
