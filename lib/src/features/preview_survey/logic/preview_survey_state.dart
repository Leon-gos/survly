import 'package:equatable/equatable.dart';

import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/src/network/model/survey_request/survey_request.dart';

class PreviewSurveyState extends Equatable {
  final Survey survey;
  final SurveyRequest? latestRequest;
  final String requestMessage;
  final int numQuestion;

  const PreviewSurveyState({
    required this.survey,
    this.latestRequest,
    required this.requestMessage,
    required this.numQuestion,
  });

  factory PreviewSurveyState.ds({required survey}) => PreviewSurveyState(
        survey: survey,
        requestMessage: "",
        numQuestion: 0,
      );

  @override
  List<Object?> get props => [
        survey,
        latestRequest,
        requestMessage,
        numQuestion,
      ];

  PreviewSurveyState copyWith({
    Survey? survey,
    SurveyRequest? latestRequest,
    String? requestMessage,
    int? numQuestion,
  }) {
    return PreviewSurveyState(
      survey: survey ?? this.survey,
      latestRequest: latestRequest ?? this.latestRequest,
      requestMessage: requestMessage ?? this.requestMessage,
      numQuestion: numQuestion ?? this.numQuestion,
    );
  }

  PreviewSurveyState removeRequest() {
    return PreviewSurveyState(
      survey: survey,
      latestRequest: null,
      requestMessage: requestMessage,
      numQuestion: numQuestion,
    );
  }
}
