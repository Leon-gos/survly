import 'package:equatable/equatable.dart';
import 'package:survly/src/network/model/do_survey/do_survey.dart';
import 'package:survly/src/network/model/survey/survey.dart';

class SurveyResponseState extends Equatable {
  final List<DoSurvey> surveyResponseList;
  final bool isLoading;
  final Survey survey;

  const SurveyResponseState({
    required this.surveyResponseList,
    required this.isLoading,
    required this.survey,
  });

  factory SurveyResponseState.ds(Survey survey) => SurveyResponseState(
        surveyResponseList: const [],
        isLoading: true,
        survey: survey,
      );

  @override
  List<Object?> get props => [surveyResponseList, isLoading, survey];

  SurveyResponseState copyWith({
    List<DoSurvey>? surveyResponseList,
    bool? isLoading,
    Survey? survey,
  }) {
    return SurveyResponseState(
      surveyResponseList: surveyResponseList ?? this.surveyResponseList,
      isLoading: isLoading ?? this.isLoading,
      survey: survey ?? this.survey,
    );
  }
}
