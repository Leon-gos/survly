import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:survly/src/network/model/question/question.dart';
import 'package:survly/src/network/model/survey/survey.dart';

class UpdateSurveyState extends Equatable {
  final Survey survey;
  final String imageLocalPath;
  final List<Question> questionList;

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController respondentController;
  final TextEditingController costController;

  factory UpdateSurveyState.ds({required Survey survey}) => UpdateSurveyState(
        survey: survey,
        imageLocalPath: "",
        questionList: const [],
        titleController: TextEditingController(text: survey.title),
        descriptionController: TextEditingController(text: survey.description),
        respondentController: TextEditingController(
          text: survey.respondentMax.toString(),
        ),
        costController: TextEditingController(
          text: survey.cost.toString(),
        ),
      );

  const UpdateSurveyState({
    required this.survey,
    required this.imageLocalPath,
    required this.questionList,
    required this.titleController,
    required this.descriptionController,
    required this.respondentController,
    required this.costController,
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
      titleController: titleController,
      descriptionController: descriptionController,
      respondentController: respondentController,
      costController: costController,
    );
  }

  @override
  List<Object?> get props => [survey, imageLocalPath, questionList];
}
