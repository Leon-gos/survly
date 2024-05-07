import 'package:flutter/material.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/model/question/question.dart';
import 'package:survly/widgets/app_text_field.dart';

class QuestionTextWidget extends StatefulWidget {
  const QuestionTextWidget({
    super.key,
    required this.question,
    required this.onAnswerChanged,
    required this.answer,
    this.readOnly = false,
  });

  final Question question;
  final String answer;
  final void Function(String answer) onAnswerChanged;
  final bool readOnly;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    textController.text = widget.answer;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).labelQuestion(
                widget.question.question,
                widget.question.questionIndex,
              ),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        AppTextField(
          textController: textController,
          onTextChange: widget.onAnswerChanged,
          readOnly: widget.readOnly,
          textInputType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          maxLines: 3,
          hintText: S.of(context).labelYourAns,
        ),
      ],
    );
  }
}
