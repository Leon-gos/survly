import 'package:flutter/material.dart';
import 'package:survly/src/network/model/question/question.dart';
import 'package:survly/src/network/model/question/question_with_options.dart';

class QuestionWidget extends StatelessWidget {
  final Question question;
  final Function()? onTap;

  const QuestionWidget({
    super.key,
    required this.question,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget questionWidget;
    if (question.questionType == QuestionType.singleOption.value) {
      questionWidget = _buildSingleOptionQuestion(context);
    } else if (question.questionType == QuestionType.multiOption.value) {
      questionWidget = _buildMultiOptionQuestion(context);
    } else {
      questionWidget = _buildTextQuestion(context);
    }

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 2,
                  color: Colors.black26,
                )
              ],
              color: Colors.white,
            ),
            child: questionWidget),
      ),
    );
  }

  Widget _buildTextQuestion(BuildContext context) {
    return Text(
      "${question.questionIndex}) ${question.question}",
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildMultiOptionQuestion(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${question.questionIndex}) ${question.question}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        for (var option in (question as QuestionWithOption).optionList)
          Row(
            children: [
              const Icon(
                Icons.check_box_outline_blank,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(option.option),
            ],
          )
      ],
    );
  }

  Widget _buildSingleOptionQuestion(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${question.questionIndex}) ${question.question}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        for (var option in (question as QuestionWithOption).optionList)
          Row(
            children: [
              const Icon(
                Icons.radio_button_off,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(option.option),
            ],
          )
      ],
    );
  }
}
