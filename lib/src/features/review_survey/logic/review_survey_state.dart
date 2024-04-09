import 'package:equatable/equatable.dart';
import 'package:survly/src/network/model/question/question.dart';
import 'package:survly/src/network/model/survey/survey.dart';

class ReviewSurveyState extends Equatable {
  final Survey survey;
  final String imageLocalPath;
  final List<Question> questionList;

  factory ReviewSurveyState.ds({required Survey survey}) => ReviewSurveyState(
        survey: survey,
        imageLocalPath: "",
        questionList: const [],
      );

  const ReviewSurveyState({
    required this.survey,
    required this.imageLocalPath,
    required this.questionList,
  });

  ReviewSurveyState copyWith({
    Survey? survey,
    String? imageLocalPath,
    List<Question>? questionList,
  }) {
    return ReviewSurveyState(
      survey: survey ?? this.survey,
      imageLocalPath: imageLocalPath ?? this.imageLocalPath,
      questionList: questionList ?? this.questionList,
    );
  }

  @override
  List<Object?> get props => [survey, imageLocalPath, questionList];
}
