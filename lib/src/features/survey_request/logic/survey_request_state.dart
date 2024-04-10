// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:survly/src/network/model/survey_request/survey_request.dart';

class SurveyRequestState extends Equatable {
  final List<SurveyRequest> surveyRequestList;

  const SurveyRequestState({required this.surveyRequestList});

  factory SurveyRequestState.ds() =>
      const SurveyRequestState(surveyRequestList: []);

  @override
  List<Object?> get props => [surveyRequestList];

  SurveyRequestState copyWith({
    List<SurveyRequest>? surveyRequestList,
  }) {
    return SurveyRequestState(
      surveyRequestList: surveyRequestList ?? this.surveyRequestList,
    );
  }
}
