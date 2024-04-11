import 'package:equatable/equatable.dart';
import 'package:survly/src/network/model/question/question.dart';
import 'package:survly/src/network/model/survey/survey.dart';

class UpdateSurveyState extends Equatable {
  final Survey survey;
  final String imageLocalPath;
  final List<Question> questionList;
  final bool isChanged;
  final bool isLoading;

  factory UpdateSurveyState.ds({required Survey survey}) => UpdateSurveyState(
        survey: survey,
        imageLocalPath: "",
        questionList: const [],
        isChanged: false,
        isLoading: false,
      );

  const UpdateSurveyState({
    required this.survey,
    required this.imageLocalPath,
    required this.questionList,
    required this.isChanged,
    required this.isLoading,
  });

  UpdateSurveyState copyWith({
    Survey? survey,
    String? imageLocalPath,
    List<Question>? questionList,
    bool? isChanged,
    bool? isLoading,
  }) {
    return UpdateSurveyState(
      survey: survey ?? this.survey,
      imageLocalPath: imageLocalPath ?? this.imageLocalPath,
      questionList: questionList ?? this.questionList,
      isChanged: isChanged ?? this.isChanged,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        survey,
        imageLocalPath,
        questionList,
        isChanged,
        isLoading,
      ];
}
