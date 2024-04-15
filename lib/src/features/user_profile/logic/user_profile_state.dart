import 'package:equatable/equatable.dart';
import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/src/network/model/user/user.dart';

class UserProfileState extends Equatable {
  final User user;
  final List<Survey> doingSurveyList;
  final List<Survey> doneSurveyList;

  const UserProfileState({
    required this.user,
    required this.doingSurveyList,
    required this.doneSurveyList,
  });

  factory UserProfileState.ds(User user) => UserProfileState(
        user: user,
        doingSurveyList: const [],
        doneSurveyList: const [],
      );

  @override
  List<Object?> get props => [];
}
