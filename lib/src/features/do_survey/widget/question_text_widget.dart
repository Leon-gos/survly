import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/network/model/question/question.dart';

class QuestionTextWidget extends StatefulWidget {
  const QuestionTextWidget({
    super.key,
    required this.question,
    required this.onAnswerChanged,
    required this.answer,
  });

  final Question question;
  final String answer;
  final void Function(String answer) onAnswerChanged;

  @override
  State<StatefulWidget> createState() => _QuestionTextWidgetState();
}

class _QuestionTextWidgetState extends State<QuestionTextWidget> {
  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController(text: widget.answer);
  }

  @override
  void dispose() {
    textController.dispose();
    Logger().d("dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    textController.text = widget.answer;
    return Column(
      children: [
        Text(
          "Question ${widget.question.questionIndex}: ${widget.question.question}",
        ),
        TextField(
          controller: textController,
          onChanged: widget.onAnswerChanged,
        )
      ],
    );
  }
}
