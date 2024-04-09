import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/features/create_survey/widget/question_editor_widget.dart';
import 'package:survly/src/features/create_survey/widget/question_widget.dart';
import 'package:survly/src/features/create_survey/widget/text_button_icon_widget.dart';
import 'package:survly/src/features/update_survey/logic/update_survey_bloc.dart';
import 'package:survly/src/features/update_survey/logic/update_survey_state.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/model/outlet/outlet.dart';
import 'package:survly/src/network/model/question/question.dart';
import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/src/router/router_name.dart';
import 'package:survly/src/theme/colors.dart';
import 'package:survly/widgets/app_app_bar.dart';
import 'package:survly/widgets/app_dialog.dart';
import 'package:survly/widgets/app_image_picker.dart';
import 'package:survly/widgets/app_text_field.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class UpdateSurveyScreen extends StatefulWidget {
  const UpdateSurveyScreen({
    super.key,
    required this.survey,
  });

  final Survey survey;

  @override
  State<StatefulWidget> createState() => _UpdateSurveyScreenState();
}

class _UpdateSurveyScreenState extends State<UpdateSurveyScreen> {
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  late final TextEditingController respondentController;
  late final TextEditingController costController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(
      text: widget.survey.title,
    );
    descriptionController = TextEditingController(
      text: widget.survey.description,
    );
    respondentController = TextEditingController(
      text: widget.survey.respondentMax.toString(),
    );
    costController = TextEditingController(
      text: widget.survey.cost.toString(),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    respondentController.dispose();
    costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UpdateSurveyBloc>(
      create: (context) => UpdateSurveyBloc(widget.survey),
      lazy: false,
      child: BlocBuilder<UpdateSurveyBloc, UpdateSurveyState>(
        buildWhen: (previous, current) => false,
        builder: (context, state) {
          return Scaffold(
            appBar: AppAppBarWidget(
              title: S.of(context).titleUpdateSurvey,
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    //TODO: publish
                  },
                  icon: const Icon(
                    Icons.share,
                    color: AppColors.white,
                  ),
                ),
                PopupMenuButton(
                  iconColor: AppColors.onPrimary,
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: Text("Save changes"),
                        onTap: () {
                          context.read<UpdateSurveyBloc>().saveSurvey();
                        },
                      ),
                      PopupMenuItem(
                        child: Text("Remove survey"),
                        onTap: () {},
                      )
                    ];
                  },
                )
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildImagePicker(),
                        _buildSurveyTextfields(),
                        const Divider(),
                        _buildQuestionList(),
                        // _buildSurveyStatus(),
                      ],
                    ),
                  ),
                ),
                _buildSurveyStatus(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuestionList() {
    return BlocBuilder<UpdateSurveyBloc, UpdateSurveyState>(
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
                                  .read<UpdateSurveyBloc>()
                                  .onQuestionListItemChange(
                                      oldQuestion, newQuestion);
                            },
                            onRemovePressed: (question) {
                              context
                                  .read<UpdateSurveyBloc>()
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
              label: Text(S.of(context).labelBtnAddQuestion),
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
    return BlocBuilder<UpdateSurveyBloc, UpdateSurveyState>(
      buildWhen: (previous, current) =>
          previous.imageLocalPath != current.imageLocalPath,
      builder: (context, state) {
        return AppImagePicker(
          onPickImage: () {
            context.read<UpdateSurveyBloc>().onPickImage();
          },
          imagePath: state.imageLocalPath,
          defaultImageUrl: state.survey.thumbnail,
        );
      },
    );
  }

  Widget _buildSurveyTextfields() {
    return BlocBuilder<UpdateSurveyBloc, UpdateSurveyState>(
      buildWhen: (previous, current) => previous.survey != current.survey,
      builder: (context, state) {
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: AppTextField(
                textController: titleController,
                hintText: S.of(context).hintSurveyTitle,
                label: S.of(context).hintSurveyTitle,
                textInputType: TextInputType.text,
                onTextChange: (newText) {
                  context.read<UpdateSurveyBloc>().onTitleChange(newText);
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: AppTextField(
                textController: descriptionController,
                hintText: S.of(context).hintSurveyDescription,
                label: S.of(context).hintSurveyDescription,
                textInputType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                onTextChange: (newText) {
                  context.read<UpdateSurveyBloc>().onDescriptionChange(newText);
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
                      textController: respondentController,
                      hintText: S.of(context).hintSurveyRespondentNumber,
                      label: S.of(context).hintSurveyRespondentNumber,
                      textInputType: TextInputType.number,
                      onTextChange: (newText) {
                        context
                            .read<UpdateSurveyBloc>()
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
                      textController: costController,
                      hintText: S.of(context).hintSurveyCost,
                      label: S.of(context).hintSurveyCost,
                      textInputType: TextInputType.number,
                      onTextChange: (newText) {
                        context.read<UpdateSurveyBloc>().onCostChange(newText);
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
                        confirmText: S.of(context).labelBtnOk,
                        cancelText: S.of(context).labelBtnCancel,
                        showActionButtons: true,
                        onSubmit: (p0) {
                          Logger().d(p0);
                          context
                              .read<UpdateSurveyBloc>()
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
                  "${S.of(context).hintDateFrom} ${state.survey.dateStart} ${S.of(context).hintDateTo} ${state.survey.dateEnd}",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                context.push(AppRouteNames.selectLocation.path).then(
                  (value) {
                    var outlet = value as Outlet?;
                    context
                        .read<UpdateSurveyBloc>()
                        .onOutletLocationChange(outlet);
                    Logger().d("(${outlet?.latitude}, ${outlet?.longitude})");
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
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${S.of(context).hintOutlet} ${state.survey.outlet?.address ?? "_"}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                      Text(
                        "${S.of(context).hintOutletCoordinate} (${state.survey.outlet?.latitude ?? "_"} , ${state.survey.outlet?.longitude ?? "_"})",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      )
                    ],
                  ),
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
              child: Text(
                S.of(context).titleDialogQuestionType,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextIconButtonWidget(
              text: QuestionType.text.label,
              icon: const Icon(Icons.abc),
              onPressed: () {
                context.read<UpdateSurveyBloc>().addQuestion(QuestionType.text);
              },
            ),
            TextIconButtonWidget(
              text: QuestionType.singleOption.label,
              icon: const Icon(Icons.radio_button_checked),
              onPressed: () {
                context
                    .read<UpdateSurveyBloc>()
                    .addQuestion(QuestionType.singleOption);
              },
            ),
            TextIconButtonWidget(
              text: QuestionType.multiOption.label,
              icon: const Icon(Icons.check_box),
              onPressed: () {
                context
                    .read<UpdateSurveyBloc>()
                    .addQuestion(QuestionType.multiOption);
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  context.pop();
                },
                child: Text(S.of(context).labelBtnCancel),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSurveyStatus() {
    return BlocBuilder<UpdateSurveyBloc, UpdateSurveyState>(
      buildWhen: (previous, current) => previous.survey != current.survey,
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            Logger().d("Tap tap tap");
            if (state.survey.status == SurveyStatus.draft.value) {
              //TODO: show dialog publish
              Logger().d("Show dialog");
              showDialog(
                context: context,
                builder: (dialogContext) {
                  return AppDialog(
                    title: "Publish survey",
                    body: "Are you sure to publish this survey?",
                    onConfirmPressed: () {
                      context.read<UpdateSurveyBloc>().publishSurvey();
                    },
                    onCancelPressed: () {},
                  );
                },
              );
            } else if (state.survey.status == SurveyStatus.openning.value) {
              //TODO: show dialog draft
            }
          },
          child: Container(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 2,
                  color: Colors.black26,
                )
              ],
              color: AppColors.white,
            ),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.all(Radius.circular(0)),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      state.survey.status == SurveyStatus.draft.value
                          ? Icons.text_snippet_outlined
                          : Icons.public,
                      color: AppColors.white,
                      size: 16,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      state.survey.status,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
