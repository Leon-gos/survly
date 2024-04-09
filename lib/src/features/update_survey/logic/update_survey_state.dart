import 'package:equatable/equatable.dart';
import 'package:survly/src/network/model/question/question.dart';
import 'package:survly/src/network/model/survey/survey.dart';

class UpdateSurveyState extends Equatable {
  final Survey survey;
  final String imageLocalPath;
  final List<Question> questionList;

  factory UpdateSurveyState.ds({required Survey survey}) => UpdateSurveyState(
        survey: survey,
        imageLocalPath: "",
        questionList: const [],
      );

  const UpdateSurveyState({
    required this.survey,
    required this.imageLocalPath,
    required this.questionList,
  });

  UpdateSurveyState copyWith({
    Survey? survey,
    String? imageLocalPath,
    List<Question>? questionList,
  }) {
    return UpdateSurveyState(
      survey: survey ?? this.survey,
      imageLocalPath: imageLocalPath ?? this.imageLocalPath,
      questionList: questionList ?? this.questionList,
    );
  }

  @override
  List<Object?> get props => [survey, imageLocalPath, questionList];
}
