import 'package:equatable/equatable.dart';

import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/src/network/model/user/user.dart';

class MyProfileState extends Equatable {
  final List<Survey> mySurveyList;
  final bool isShowProfile;

  const MyProfileState({
    required this.mySurveyList,
    required this.isShowProfile,
  });

  factory MyProfileState.ds(User user) => const MyProfileState(
        mySurveyList: [],
        isShowProfile: true,
      );

  @override
  List<Object?> get props => [
        mySurveyList,
        isShowProfile,
      ];

  MyProfileState copyWith({
    List<Survey>? mySurveyList,
    bool? isShowProfile,
  }) {
    return MyProfileState(
      mySurveyList: mySurveyList ?? this.mySurveyList,
      isShowProfile: isShowProfile ?? this.isShowProfile,
    );
  }
}
