import 'dart:convert';

import 'package:survly/src/localization/localization_utils.dart';

class QuestionOption {
  String questionOptionId;
  int questionOptionIndex;
  String option;
  String questionId;

  String? getError() {
    if (option == "") {
      return S.text.errorOptionContentEmpty;
    }
    return null;
  }

  QuestionOption({
    this.questionOptionId = "",
    required this.questionOptionIndex,
    this.option = "",
    this.questionId = "",
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'questionOptionId': questionOptionId,
      'questionOptionIndex': questionOptionIndex,
      'option': option,
      'questionId': questionId,
    };
  }

  factory QuestionOption.fromMap(Map<String, dynamic> map) {
    return QuestionOption(
      questionOptionId: map['questionOptionId'] as String,
      questionOptionIndex: map['questionOptionIndex'] as int,
      option: map['option'] as String,
      questionId: map['questionId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestionOption.fromJson(String source) =>
      QuestionOption.fromMap(json.decode(source) as Map<String, dynamic>);
}
