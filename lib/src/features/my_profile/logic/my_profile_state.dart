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

  int get countDoing {
    return doSurveyList
        .where((element) =>
            element.status == DoSurveyStatus.doing.value ||
            element.status == DoSurveyStatus.submitted.value)
        .length;
  }

  int get countDone {
    return doSurveyList
        .where((element) =>
            element.status == DoSurveyStatus.approved.value ||
            element.status == DoSurveyStatus.ignored.value)
        .length;
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
