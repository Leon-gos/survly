import 'package:flutter/material.dart';
import 'package:survly/src/localization/localization_utils.dart';

import 'package:survly/src/network/model/question/question.dart';
import 'package:survly/src/network/model/question/question_with_options.dart';
import 'package:survly/src/router/coordinator.dart';

class QuestionEditorWidget extends StatefulWidget {
  final Question question;
  final Function(Question oldQuestion, Question newQuestion) onSavePressed;
  final Function()? onCancelPressed;
  final Function(Question question) onRemovePressed;

  const QuestionEditorWidget({
    super.key,
    required this.question,
    required this.onSavePressed,
    this.onCancelPressed,
    required this.onRemovePressed,
  });

  @override
  State<StatefulWidget> createState() => _QuestionEditorWidgetState();
}

class _QuestionEditorWidgetState extends State<QuestionEditorWidget> {
  final double padding = 16;
  late Question questionTemp;

  @override
  void initState() {
    super.initState();
    if (widget.question.questionType == QuestionType.text.value) {
      questionTemp = widget.question.copyWith();
    } else {
      questionTemp = (widget.question as QuestionWithOption).copyWith();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(padding),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.of(context).labelQuestionContent),
                    TextField(
                      decoration:
                          InputDecoration(hintText: questionTemp.question),
                      onChanged: (value) {
                        setState(() {
                          questionTemp.question = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildOptions(context),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    widget.onCancelPressed?.call();
                    AppCoordinator.pop();
                  },
                  child: Text(S.of(context).labelBtnCancel),
                ),
                TextButton(
                  onPressed: () {
                    widget.onRemovePressed.call(widget.question);
                    AppCoordinator.pop();
                  },
                  child: Text(S.of(context).labelBtnRemove),
                ),
                TextButton(
                  onPressed: () {
                    widget.onSavePressed.call(widget.question, questionTemp);
                    AppCoordinator.pop();
                  },
                  child: Text(S.of(context).labelBtnUpdate),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOptions(BuildContext context) {
    if (questionTemp.questionType == QuestionType.singleOption.value ||
        questionTemp.questionType == QuestionType.multiOption.value) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(S.of(context).labelOptions),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Wrap(
              direction: Axis.vertical,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: (questionTemp as QuestionWithOption).optionList.map(
                (e) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width - padding * 2,
                    child: Row(
                      children: [
                        Text("${e.questionOptionIndex}) "),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            decoration: InputDecoration(hintText: e.option),
                            onChanged: (value) {
                              setState(() {
                                e.option = value;
                              });
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              (questionTemp as QuestionWithOption)
                                  .removeOption(e);
                            });
                          },
                          icon: const Icon(Icons.remove_circle_outline),
                        )
                      ],
                    ),
                  );
                },
              ).toList(),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Align(
            alignment: Alignment.center,
            child: IconButton(
              onPressed: () {
                setState(() {
                  (questionTemp as QuestionWithOption).addOption();
                });
              },
              icon: const Icon(Icons.add_circle_outline_outlined),
            ),
          )
        ],
      );
    }
    return const SizedBox();
  }
}
