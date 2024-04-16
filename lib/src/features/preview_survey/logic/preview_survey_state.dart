import 'package:equatable/equatable.dart';

import 'package:survly/src/network/model/survey/survey.dart';

class PreviewSurveyState extends Equatable {
  final Survey survey;

  const PreviewSurveyState({required this.survey});

  factory PreviewSurveyState.ds({required survey}) =>
      PreviewSurveyState(survey: survey);

  @override
  List<Object?> get props => [survey];

  PreviewSurveyState copyWith({
    Survey? survey,
  }) {
    return PreviewSurveyState(
      survey: survey ?? this.survey,
    );
  }
}
