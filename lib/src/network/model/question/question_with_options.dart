import 'dart:convert';

import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/model/question/question.dart';
import 'package:survly/src/network/model/question_option/question_option.dart';

class QuestionWithOption extends Question {
  static const int defaultSampleOptionNum = 3;

  List<QuestionOption> optionList;

  @override
  String? getError() {
    super.getError();
    if (optionList.isEmpty) {
      return S.text.errorOptionEmpty;
    }
    for (var option in optionList) {
      if (option.getError() != null) {
        return option.getError();
      }
    }
    return null;
  }

  QuestionWithOption({
    super.questionId = "",
    required super.questionIndex,
    super.question = "",
    required super.questionType,
    super.surveyId = "",
    required this.optionList,
  });

  factory QuestionWithOption.sample({
    required int questionIndex,
    String question = "",
    required String questionType,
    String surveyId = "",
    required List<QuestionOption> optionList,
  }) {
    var questionWithOption = QuestionWithOption(
      questionIndex: questionIndex,
      questionType: questionType,
      question: question,
      optionList: optionList,
    );
    for (int i = 0; i < defaultSampleOptionNum; i++) {
      questionWithOption.addOption();
    }
    return questionWithOption;
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'questionId': questionId,
      'questionIndex': questionIndex,
      'question': question,
      'questionType': questionType,
      'surveyId': surveyId,
    };
  }

  factory QuestionWithOption.fromMap(Map<String, dynamic> map) {
    return QuestionWithOption(
        questionId: map['questionId']?.toString() ?? "",
        questionIndex: int.parse(map['questionIndex']?.toString() ?? "0"),
        question: map['question']?.toString() ?? "",
        questionType: map['questionType']?.toString() ?? "",
        surveyId: map['surveyId']?.toString() ?? "",
        optionList: (map['optionList'] ?? []) as List<QuestionOption>);
  }

  @override
  String toJson() => json.encode(toMap());

  factory QuestionWithOption.fromJson(String source) =>
      QuestionWithOption.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  QuestionWithOption copyWith({
    String? questionId,
    int? questionIndex,
    String? question,
    String? questionType,
    String? surveyId,
    List<QuestionOption>? optionList,
  }) {
    return QuestionWithOption(
      questionId: questionId ?? this.questionId,
      questionIndex: questionIndex ?? this.questionIndex,
      question: question ?? this.question,
      questionType: questionType ?? this.questionType,
      surveyId: surveyId ?? this.surveyId,
      optionList: optionList ?? List.of(this.optionList),
    );
  }

  void removeOption(QuestionOption option) {
    optionList.remove(option);
    for (int i = 0; i < optionList.length; i++) {
      optionList[i].questionOptionIndex = i + 1;
    }
  }

  void addOption() {
    optionList.add(
      QuestionOption(
        questionOptionIndex: optionList.length + 1,
        option: "${S.text.hintSurveyOption} ${optionList.length + 1}",
      ),
    );
  }
}
