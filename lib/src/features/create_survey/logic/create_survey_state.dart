import 'package:equatable/equatable.dart';
import 'package:survly/src/network/model/question/question.dart';
import 'package:survly/src/network/model/survey/survey.dart';

class CreateSurveyState extends Equatable {
  final Survey survey;
  final String imageLocalPath;
  final List<Question> questionList;

  factory CreateSurveyState.ds() => CreateSurveyState(
        survey: Survey(),
        imageLocalPath: "",
        questionList: const [],
      );

  const CreateSurveyState({
    required this.survey,
    required this.imageLocalPath,
    required this.questionList,
  });

  CreateSurveyState copyWith({
    Survey? survey,
    String? imageLocalPath,
    List<Question>? questionList,
  }) {
    return CreateSurveyState(
      survey: survey ?? this.survey,
      imageLocalPath: imageLocalPath ?? this.imageLocalPath,
      questionList: questionList ?? this.questionList,
    );
  }

  @override
  List<Object?> get props => [survey, imageLocalPath, questionList];
}
