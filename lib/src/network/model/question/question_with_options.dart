import 'dart:convert';

import 'package:survly/src/network/model/question/question.dart';
import 'package:survly/src/network/model/question_option/question_option.dart';

class QuestionWithOption extends Question {
  List<QuestionOption> optionList;

  QuestionWithOption({
    super.questionId = "",
    required super.questionIndex,
    super.question = "",
    required super.questionType,
    super.surveyId = "",
    this.optionList = const [],
  });

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'questionId': questionId,
      'questionIndex': questionIndex,
      'question': question,
      'questionType': questionType,
      'surveyId': surveyId,
      'optionList': optionList
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
}
