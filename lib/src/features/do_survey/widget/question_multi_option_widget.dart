import 'package:flutter/material.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/model/question/question_with_options.dart';

class QuestionMultiOptionWidget extends StatefulWidget {
  const QuestionMultiOptionWidget({
    super.key,
    required this.question,
    required this.answers,
    required this.onAnswerChanged,
  });

  final QuestionWithOption question;
  final void Function(String option) onAnswerChanged;
  final Set<String> answers;

  @override
  State<StatefulWidget> createState() => _QuestionMultiOptionWidgetState();
}

class _QuestionMultiOptionWidgetState extends State<QuestionMultiOptionWidget> {
  bool isChecked(String id) {
    return widget.answers.contains(id);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).labelQuestion(
                widget.question.questionIndex,
                widget.question.question,
              ),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        for (var option in widget.question.optionList)
          CheckboxListTile(
            value: isChecked(option.questionOptionId),
            title: Text(option.option),
            onChanged: (value) {
              widget.onAnswerChanged(option.questionOptionId);
              setState(() {
                if (value == true) {
                  widget.answers.add(option.questionOptionId);
                } else {
                  widget.answers.remove(option.questionOptionId);
                }
              });
            },
          )
      ],
    );
  }
}
