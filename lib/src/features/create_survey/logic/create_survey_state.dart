import 'package:equatable/equatable.dart';
import 'package:survly/src/network/model/survey/survey.dart';

class CreateSurveyState extends Equatable {
  final Survey survey;
  final String imageLocalPath;

  factory CreateSurveyState.ds() =>
      CreateSurveyState(survey: Survey(), imageLocalPath: "");

  const CreateSurveyState({required this.survey, required this.imageLocalPath});

  CreateSurveyState copyWith({
    Survey? survey,
    String? imageLocalPath,
  }) {
    return CreateSurveyState(
      survey: survey ?? this.survey,
      imageLocalPath: imageLocalPath ?? this.imageLocalPath,
    );
  }

  @override
  List<Object?> get props => [survey, imageLocalPath];
}
