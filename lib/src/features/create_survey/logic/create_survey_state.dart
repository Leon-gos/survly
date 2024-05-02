import 'package:equatable/equatable.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/network/model/question/question.dart';
import 'package:survly/src/network/model/survey/survey.dart';

class CreateSurveyState extends Equatable {
  final Survey survey;
  final String imageLocalPath;
  final List<Question> questionList;
  final bool isLoading;

  factory CreateSurveyState.ds() => CreateSurveyState(
        survey: Survey.draft(
            adminId: UserBaseSingleton.instance().userBase?.id ?? ""),
        imageLocalPath: "",
        questionList: const [],
        isLoading: false,
      );

  const CreateSurveyState({
    required this.survey,
    required this.imageLocalPath,
    required this.questionList,
    required this.isLoading,
  });

  CreateSurveyState copyWith({
    Survey? survey,
    String? imageLocalPath,
    List<Question>? questionList,
    bool? isLoading,
  }) {
    return CreateSurveyState(
      survey: survey ?? this.survey,
      imageLocalPath: imageLocalPath ?? this.imageLocalPath,
      questionList: questionList ?? this.questionList,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        survey,
        imageLocalPath,
        questionList,
        isLoading,
      ];
}
