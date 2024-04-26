import 'package:equatable/equatable.dart';

import 'package:survly/src/network/model/survey/survey.dart';

class AdminProfileState extends Equatable {
  final List<Survey> adminSurveyList;
  final bool isShowProfile;

  const AdminProfileState({
    required this.adminSurveyList,
    required this.isShowProfile,
  });

  factory AdminProfileState.ds() => const AdminProfileState(
        adminSurveyList: [],
        isShowProfile: true,
      );

  @override
  List<Object?> get props => [
        adminSurveyList,
        isShowProfile,
      ];

  AdminProfileState copyWith({
    List<Survey>? adminSurveyList,
    bool? isShowProfile,
  }) {
    return AdminProfileState(
      adminSurveyList: adminSurveyList ?? this.adminSurveyList,
      isShowProfile: isShowProfile ?? this.isShowProfile,
    );
  }
}
