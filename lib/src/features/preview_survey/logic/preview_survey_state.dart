// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:survly/src/network/model/survey/survey.dart';

class PreviewSurveyState extends Equatable {
  final Survey survey;
  final bool hasRequested;

  const PreviewSurveyState({
    required this.survey,
    required this.hasRequested,
  });

  factory PreviewSurveyState.ds({required survey}) => PreviewSurveyState(
        survey: survey,
        hasRequested: false,
      );

  @override
  List<Object?> get props => [survey, hasRequested];

  PreviewSurveyState copyWith({
    Survey? survey,
    bool? hasRequested,
  }) {
    return PreviewSurveyState(
      survey: survey ?? this.survey,
      hasRequested: hasRequested ?? this.hasRequested,
    );
  }
}
