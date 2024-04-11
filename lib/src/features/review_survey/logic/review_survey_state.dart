import 'package:equatable/equatable.dart';
import 'package:survly/src/network/model/question/question.dart';
import 'package:survly/src/network/model/survey/survey.dart';

class ReviewSurveyState extends Equatable {
  final Survey survey;
  final List<Question> questionList;
  final bool isChanged;

  factory ReviewSurveyState.ds({required Survey survey}) => ReviewSurveyState(
        survey: survey,
        questionList: const [],
        isChanged: false,
      );

  const ReviewSurveyState({
    required this.survey,
    required this.questionList,
    required this.isChanged,
  });

  ReviewSurveyState copyWith({
    Survey? survey,
    List<Question>? questionList,
    bool? isChanged,
  }) {
    return ReviewSurveyState(
      survey: survey ?? this.survey,
      questionList: questionList ?? this.questionList,
      isChanged: isChanged ?? this.isChanged,
    );
  }

  @override
  List<Object?> get props => [survey, questionList, isChanged];
}
