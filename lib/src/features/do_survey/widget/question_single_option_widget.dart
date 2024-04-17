import 'package:flutter/material.dart';
import 'package:survly/src/network/model/question/question_with_options.dart';

class QuestionSingleOptionWidget extends StatefulWidget {
  const QuestionSingleOptionWidget({
    super.key,
    required this.question,
    required this.answer,
    required this.onAnswerChanged,
  });

  final QuestionWithOption question;
  final void Function(String option) onAnswerChanged;
  final String answer;

  @override
  State<StatefulWidget> createState() => _QuestionSingleOptionWidgetState();
}

class _QuestionSingleOptionWidgetState
    extends State<QuestionSingleOptionWidget> {
  late String tempAns;
  @override
  void initState() {
    super.initState();
    tempAns = widget.answer;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Question ${widget.question.questionIndex}: ${widget.question.question}",
        ),
        for (var option in widget.question.optionList)
          RadioListTile(
            value: option.questionOptionId,
            groupValue: tempAns,
            title: Text(option.option),
            onChanged: (value) {
              widget.onAnswerChanged(value!);
              setState(() {
                tempAns = value;
              });
            },
          )
      ],
    );
  }
}
