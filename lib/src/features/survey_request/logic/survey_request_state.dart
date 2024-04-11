// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/src/network/model/survey_request/survey_request.dart';

class SurveyRequestState extends Equatable {
  final List<SurveyRequest> surveyRequestList;
  final bool isLoading;
  final Survey survey;

  const SurveyRequestState({
    required this.surveyRequestList,
    required this.isLoading,
    required this.survey,
  });

  factory SurveyRequestState.ds(Survey survey) => SurveyRequestState(
        surveyRequestList: const [],
        isLoading: true,
        survey: survey,
      );

  @override
  List<Object?> get props => [surveyRequestList, isLoading, survey];

  SurveyRequestState copyWith({
    List<SurveyRequest>? surveyRequestList,
    bool? isLoading,
    Survey? survey,
  }) {
    return SurveyRequestState(
      surveyRequestList: surveyRequestList ?? this.surveyRequestList,
      isLoading: isLoading ?? this.isLoading,
      survey: survey ?? this.survey,
    );
  }
}
