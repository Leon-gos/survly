import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/features/create_survey/logic/create_survey_bloc.dart';
import 'package:survly/src/features/create_survey/logic/create_survey_state.dart';
import 'package:survly/src/features/create_survey/widget/question_editor_widget.dart';
import 'package:survly/src/features/create_survey/widget/question_widget.dart';
import 'package:survly/src/features/create_survey/widget/text_button_icon_widget.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/model/question/question.dart';
import 'package:survly/src/theme/colors.dart';
import 'package:survly/widgets/app_app_bar.dart';
import 'package:survly/widgets/app_image_picker.dart';
import 'package:survly/widgets/app_text_field.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CreateSurveyScreen extends StatelessWidget {
  const CreateSurveyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateSurveyBloc>(
      create: (context) => CreateSurveyBloc(),
      lazy: false,
      child: BlocBuilder<CreateSurveyBloc, CreateSurveyState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppAppBarWidget(
              title: S.of(context).titleCreateSurvey,
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    context.read<CreateSurveyBloc>().saveSurvey();
                  },
                  icon: const Icon(
                    Icons.save,
                    color: AppColors.white,
                  ),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  _buildImagePicker(),
                  _buildSurveyTextfields(),
                  const Divider(),
                  _buildQuestionList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuestionList() {
    return BlocBuilder<CreateSurveyBloc, CreateSurveyState>(
      buildWhen: (previous, current) =>
          previous.questionList != current.questionList,
      builder: (context, state) {
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.start,
                children: state.questionList.map((e) {
                  return QuestionWidget(
                    question: e,
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (dialogContext) {
                          return QuestionEditorWidget(
                            question: e,
                            onSavePressed: (oldQuestion, newQuestion) {
                              context
                                  .read<CreateSurveyBloc>()
                                  .onQuestionListItemChange(
                                      oldQuestion, newQuestion);
                            },
                            onRemovePressed: (question) {
                              context
                                  .read<CreateSurveyBloc>()
                                  .removeQuestion(question);
                            },
                            onCancelPressed: () {},
                          );
                        },
                      );
                    },
                  );
                }).toList(),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) {
                    return _buildDialogSelectQuestionType(context);
                  },
                );
              },
              icon: const Icon(Icons.add_box_outlined),
              label: const Text("Add question"),
            ),
            const SizedBox(
              height: 100,
            )
          ],
        );
      },
    );
  }

  Widget _buildImagePicker() {
    return BlocBuilder<CreateSurveyBloc, CreateSurveyState>(
      buildWhen: (previous, current) =>
          previous.imageLocalPath != current.imageLocalPath,
      builder: (context, state) {
        return AppImagePicker(
          onPickImage: () {
            context.read<CreateSurveyBloc>().onPickImage();
          },
          imagePath: state.imageLocalPath,
        );
      },
    );
  }

  Widget _buildSurveyTextfields() {
    return BlocBuilder<CreateSurveyBloc, CreateSurveyState>(
      buildWhen: (previous, current) => previous.survey != current.survey,
      builder: (context, state) {
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: AppTextField(
                hintText: "Title",
                label: "Title",
                textInputType: TextInputType.text,
                onTextChange: (newText) {
                  context.read<CreateSurveyBloc>().onTitleChange(newText);
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: AppTextField(
                hintText: "Description",
                label: "Description",
                textInputType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                onTextChange: (newText) {
                  context.read<CreateSurveyBloc>().onDescriptionChange(newText);
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: AppTextField(
                      hintText: "Respondent number",
                      label: "Respondent number",
                      textInputType: TextInputType.number,
                      onTextChange: (newText) {
                        context
                            .read<CreateSurveyBloc>()
                            .onRespondentNumberChange(newText);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    flex: 1,
                    child: AppTextField(
                      hintText: "Cost",
                      label: "Cost",
                      textInputType: TextInputType.number,
                      onTextChange: (newText) {
                        context.read<CreateSurveyBloc>().onCostChange(newText);
                      },
                    ),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  useSafeArea: true,
                  builder: (newContext) {
                    return SizedBox(
                      width: double.infinity,
                      height: 400,
                      child: SfDateRangePicker(
                        backgroundColor: AppColors.white,
                        confirmText: "OK",
                        cancelText: "Cancel",
                        showActionButtons: true,
                        onSubmit: (p0) {
                          Logger().d(p0);
                          context
                              .read<CreateSurveyBloc>()
                              .onDateRangeChange(p0 as PickerDateRange);
                          context.pop();
                        },
                        onCancel: () {
                          context.pop();
                        },
                        headerStyle: const DateRangePickerHeaderStyle(
                          backgroundColor: AppColors.secondary,
                          textStyle: TextStyle(color: AppColors.white),
                        ),
                        view: DateRangePickerView.month,
                        selectionMode: DateRangePickerSelectionMode.range,
                      ),
                    );
                  },
                );
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(width: 1.5, color: Colors.grey),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                child: Text(
                  "From ${state.survey.dateStart} to ${state.survey.dateEnd}",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildDialogSelectQuestionType(BuildContext context) {
    return Dialog(
      child: Container(
        width: (MediaQuery.of(context).size.width / 10) * 8,
        padding: const EdgeInsets.all(16),
        color: AppColors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              child: const Text(
                "Question type",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextIconButtonWidget(
              text: "Text",
              icon: const Icon(Icons.abc),
              onPressed: () {
                context.read<CreateSurveyBloc>().addQuestion(QuestionType.text);
              },
            ),
            TextIconButtonWidget(
              text: "Single option",
              icon: const Icon(Icons.radio_button_checked),
              onPressed: () {
                context
                    .read<CreateSurveyBloc>()
                    .addQuestion(QuestionType.singleOption);
              },
            ),
            TextIconButtonWidget(
              text: "Multiple option",
              icon: const Icon(Icons.check_box),
              onPressed: () {
                context
                    .read<CreateSurveyBloc>()
                    .addQuestion(QuestionType.multiOption);
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text("Cancel"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
