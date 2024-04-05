import 'dart:convert';

class QuestionOption {
  String questionOptionId;
  String option;
  String questionId;
  QuestionOption({
    required this.questionOptionId,
    required this.option,
    required this.questionId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'questionOptionId': questionOptionId,
      'option': option,
      'questionId': questionId,
    };
  }

  factory QuestionOption.fromMap(Map<String, dynamic> map) {
    return QuestionOption(
      questionOptionId: map['questionOptionId'] as String,
      option: map['option'] as String,
      questionId: map['questionId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestionOption.fromJson(String source) =>
      QuestionOption.fromMap(json.decode(source) as Map<String, dynamic>);
}
