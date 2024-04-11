import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/features/create_survey/widget/question_widget.dart';
import 'package:survly/src/features/review_survey/logic/review_survey_bloc.dart';
import 'package:survly/src/features/review_survey/logic/review_survey_state.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/src/router/router_name.dart';
import 'package:survly/src/theme/colors.dart';
import 'package:survly/widgets/app_app_bar.dart';
import 'package:survly/widgets/app_dialog.dart';
import 'package:survly/widgets/app_image_picker.dart';
import 'package:survly/widgets/app_text_field.dart';

class ReviewSurveyScreen extends StatefulWidget {
  const ReviewSurveyScreen({super.key, required this.survey});

  final Survey survey;

  @override
  State<StatefulWidget> createState() => _ReviewSurveyState();
}

class _ReviewSurveyState extends State<ReviewSurveyScreen> {
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

  void refreshTextController(Survey? survey) {
    if (survey != null) {
      Logger().d("title: ${survey.title}");
      titleController.text = survey.title;
      descriptionController.text = survey.description;
      respondentController.text = survey.respondentMax.toString();
      costController.text = survey.cost.toString();
    }
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
    return BlocProvider<ReviewSurveyBloc>(
      create: (context) => ReviewSurveyBloc(widget.survey),
      lazy: false,
      child: BlocBuilder<ReviewSurveyBloc, ReviewSurveyState>(
        buildWhen: (previous, current) => previous.survey != current.survey,
        builder: (context, state) {
          return Scaffold(
            appBar: AppAppBarWidget(
              title: S.of(context).titleReviewSurvey,
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    //TODO: share
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
                        child: Text(S.of(context).labelBtnViewAsUser),
                        onTap: () {},
                      ),
                      if (state.survey.status == SurveyStatus.public.value)
                        PopupMenuItem(
                          child: Text(S.of(context).labelBtnViewRequestList),
                          onTap: () {
                            context.push(
                              AppRouteNames.surveyRequest.path,
                              extra: state.survey,
                            );
                          },
                        ),
                      if (state.survey
                          .ableToEdit(AdminSingleton.instance().admin?.id)) ...[
                        PopupMenuItem(
                          child: Text(S.of(context).labelBtnEdit),
                          onTap: () {
                            context.push(
                              AppRouteNames.updateSurvey.path,
                              extra: state.survey,
                            );
                          },
                        ),
                        PopupMenuItem(
                          child: Text(S.of(context).labelBtnRemove),
                          onTap: () {},
                        ),
                      ],
                    ];
                  },
                )
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                await context.read<ReviewSurveyBloc>().onRefresh().then(
                  (value) {
                    refreshTextController(value);
                  },
                );
              },
              child: Column(
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
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuestionList() {
    return BlocBuilder<ReviewSurveyBloc, ReviewSurveyState>(
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
                  return QuestionWidget(question: e);
                }).toList(),
              ),
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
    return BlocBuilder<ReviewSurveyBloc, ReviewSurveyState>(
      buildWhen: (previous, current) => previous.survey != current.survey,
      builder: (context, state) {
        return AppImagePicker(
          onPickImage: () {},
          imagePath: "",
          defaultImageUrl: state.survey.thumbnail,
        );
      },
    );
  }

  Widget _buildSurveyTextfields() {
    return BlocBuilder<ReviewSurveyBloc, ReviewSurveyState>(
      buildWhen: (previous, current) => previous.survey != current.survey,
      builder: (context, state) {
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: AppTextField(
                textController: titleController,
                label: S.of(context).hintSurveyTitle,
                readOnly: true,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: AppTextField(
                textController: descriptionController,
                label: S.of(context).hintSurveyDescription,
                textInputType: TextInputType.multiline,
                readOnly: true,
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
                      label: S.of(context).hintSurveyRespondentNumber,
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    flex: 1,
                    child: AppTextField(
                      textController: costController,
                      label: S.of(context).hintSurveyCost,
                      readOnly: true,
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
            GestureDetector(
              onTap: () async {
                context.push(
                  AppRouteNames.selectLocation.path,
                  extra: state.survey.outlet,
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

  Widget _buildSurveyStatus() {
    return BlocBuilder<ReviewSurveyBloc, ReviewSurveyState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            if (state.survey.status == SurveyStatus.draft.value) {
              String? publishError = state.survey.getPublishError(
                AdminSingleton.instance().admin?.id,
                state.questionList,
              );
              if (publishError != null) {
                Fluttertoast.showToast(msg: publishError);
              } else {
                showDialog(
                  context: context,
                  builder: (dialogContext) {
                    return AppDialog(
                      title: S.of(context).dialogTitlePublishSurvey,
                      body: S.of(context).dialogBodyPublishSurvey,
                      onConfirmPressed: () {
                        context.read<ReviewSurveyBloc>().publishSurvey();
                      },
                      onCancelPressed: () {},
                    );
                  },
                );
              }
            } else if (state.survey.status == SurveyStatus.public.value) {
              String? draftError = state.survey.getDraftError(
                AdminSingleton.instance().admin?.id,
              );
              if (draftError != null) {
                Fluttertoast.showToast(msg: draftError);
              } else {
                showDialog(
                  context: context,
                  builder: (dialogContext) {
                    return AppDialog(
                      title: S.of(context).dialogTitleDraftSurvey,
                      body: S.of(context).dialogBodyDraftSurvey,
                      onConfirmPressed: () {
                        context.read<ReviewSurveyBloc>().draftSurvey();
                      },
                      onCancelPressed: () {},
                    );
                  },
                );
              }
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
              decoration: BoxDecoration(
                color: state.survey.status == SurveyStatus.public.value
                    ? AppColors.primary
                    : AppColors.secondary,
                borderRadius: const BorderRadius.all(Radius.circular(0)),
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
