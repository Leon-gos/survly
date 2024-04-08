import 'package:equatable/equatable.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/network/model/outlet/outlet.dart';
import 'package:survly/src/network/model/question/question.dart';
import 'package:survly/src/network/model/survey/survey.dart';

class CreateSurveyState extends Equatable {
  final Survey survey;
  final String imageLocalPath;
  final List<Question> questionList;
  final Outlet? outlet;

  factory CreateSurveyState.ds() => CreateSurveyState(
        survey: Survey(adminId: AdminSingleton.instance().admin?.id ?? ""),
        imageLocalPath: "",
        questionList: const [],
        outlet: null,
      );

  const CreateSurveyState({
    required this.survey,
    required this.imageLocalPath,
    required this.questionList,
    required this.outlet,
  });

  CreateSurveyState copyWith({
    Survey? survey,
    String? imageLocalPath,
    List<Question>? questionList,
    Outlet? outlet,
  }) {
    return CreateSurveyState(
      survey: survey ?? this.survey,
      imageLocalPath: imageLocalPath ?? this.imageLocalPath,
      questionList: questionList ?? this.questionList,
      outlet: outlet ?? this.outlet,
    );
  }

  @override
  List<Object?> get props => [survey, imageLocalPath, questionList, outlet];
}
