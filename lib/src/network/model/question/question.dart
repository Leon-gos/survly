// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

enum QuestionType {
  text(value: "text"),
  singleOption(value: "singleOption"),
  multiOption(value: "multiOption");

  final String value;

  const QuestionType({required this.value});
}

class Question {
  String questionId;
  int questionIndex;
  String question;
  String questionType;
  String surveyId;

  Question({
    this.questionId = "",
    required this.questionIndex,
    this.question = "",
    required this.questionType,
    this.surveyId = "",
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'questionId': questionId,
      'questionIndex': questionIndex,
      'question': question,
      'questionType': questionType,
      'surveyId': surveyId,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      questionId: map['questionId']?.toString() ?? "",
      questionIndex: int.parse(map['questionIndex']?.toString() ?? "0"),
      question: map['question']?.toString() ?? "",
      questionType: map['questionType']?.toString() ?? "",
      surveyId: map['surveyId']?.toString() ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory Question.fromJson(String source) =>
      Question.fromMap(json.decode(source) as Map<String, dynamic>);

  Question copyWith({
    String? questionId,
    int? questionIndex,
    String? question,
    String? questionType,
    String? surveyId,
  }) {
    return Question(
      questionId: questionId ?? this.questionId,
      questionIndex: questionIndex ?? this.questionIndex,
      question: question ?? this.question,
      questionType: questionType ?? this.questionType,
      surveyId: surveyId ?? this.surveyId,
    );
  }
}
