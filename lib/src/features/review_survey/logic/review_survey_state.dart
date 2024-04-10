import 'package:equatable/equatable.dart';
import 'package:survly/src/network/model/question/question.dart';
import 'package:survly/src/network/model/survey/survey.dart';

class ReviewSurveyState extends Equatable {
  final Survey survey;
  final List<Question> questionList;

  factory ReviewSurveyState.ds({required Survey survey}) => ReviewSurveyState(
        survey: survey,
        questionList: const [],
      );

  const ReviewSurveyState({
    required this.survey,
    required this.questionList,
  });

  ReviewSurveyState copyWith({
    Survey? survey,
    List<Question>? questionList,
  }) {
    return ReviewSurveyState(
      survey: survey ?? this.survey,
      questionList: questionList ?? this.questionList,
    );
  }

  @override
  List<Object?> get props => [survey, questionList];
}
