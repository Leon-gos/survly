import 'package:equatable/equatable.dart';

import 'package:survly/src/network/model/survey/survey.dart';

class AdminProfileState extends Equatable {
  final List<Survey> adminSurveyList;

  const AdminProfileState({required this.adminSurveyList});

  factory AdminProfileState.ds() => const AdminProfileState(
        adminSurveyList: [],
      );

  @override
  List<Object?> get props => [];

  AdminProfileState copyWith({
    List<Survey>? adminSurveyList,
  }) {
    return AdminProfileState(
      adminSurveyList: adminSurveyList ?? this.adminSurveyList,
    );
  }
}
