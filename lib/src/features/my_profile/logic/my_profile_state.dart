import 'package:equatable/equatable.dart';
import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/src/network/model/user/user.dart';

class MyProfileState extends Equatable {
  final User user;
  final List<Survey> doingSurveyList;
  final List<Survey> doneSurveyList;

  const MyProfileState({
    required this.user,
    required this.doingSurveyList,
    required this.doneSurveyList,
  });

  factory MyProfileState.ds(User user) => MyProfileState(
        user: user,
        doingSurveyList: const [],
        doneSurveyList: const [],
      );

  @override
  List<Object?> get props => [user, doingSurveyList, doneSurveyList];
}
