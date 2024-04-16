import 'package:equatable/equatable.dart';

import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/src/network/model/survey_request/survey_request.dart';

class PreviewSurveyState extends Equatable {
  final Survey survey;
  final SurveyRequest? latestRequest;
  final String requestMessage;

  const PreviewSurveyState({
    required this.survey,
    this.latestRequest,
    required this.requestMessage,
  });

  factory PreviewSurveyState.ds({required survey}) => PreviewSurveyState(
        survey: survey,
        requestMessage: "",
      );

  @override
  List<Object?> get props => [survey, latestRequest, requestMessage];

  PreviewSurveyState copyWith({
    Survey? survey,
    SurveyRequest? latestRequest,
    String? requestMessage,
  }) {
    return PreviewSurveyState(
      survey: survey ?? this.survey,
      latestRequest: latestRequest ?? this.latestRequest,
      requestMessage: requestMessage ?? this.requestMessage,
    );
  }

  PreviewSurveyState removeRequest() {
    return PreviewSurveyState(
      survey: survey,
      latestRequest: null,
      requestMessage: requestMessage,
    );
  }
}
