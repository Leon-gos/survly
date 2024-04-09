import 'dart:convert';

enum QuestionType {
  text(value: "text", label: "Text"),
  singleOption(value: "singleOption", label: "Single option"),
  multiOption(value: "multiOption", label: "Multiple option");

  final String value;
  final String label;

  const QuestionType({required this.value, required this.label});
}

class Question {
  String questionId;
  int questionIndex;
  String question;
  String questionType;
  String surveyId;

  String? getError() {
    if (question == "") {
      return "Question empty";
    }
    return null;
  }

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
