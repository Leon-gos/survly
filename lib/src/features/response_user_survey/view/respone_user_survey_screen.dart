import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:survly/src/features/do_survey/widget/question_multi_option_widget.dart';
import 'package:survly/src/features/do_survey/widget/question_single_option_widget.dart';
import 'package:survly/src/features/do_survey/widget/question_text_widget.dart';
import 'package:survly/src/features/response_user_survey/logic/response_user_survey_bloc.dart';
import 'package:survly/src/features/response_user_survey/logic/response_user_survey_state.dart';
import 'package:survly/src/features/response_user_survey/widget/response_button_widget.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/model/question/question.dart';
import 'package:survly/src/network/model/question/question_with_options.dart';
import 'package:survly/src/theme/colors.dart';
import 'package:survly/widgets/app_app_bar.dart';
import 'package:survly/widgets/app_dialog.dart';
import 'package:survly/widgets/app_image_picker.dart';
import 'package:survly/widgets/app_loading_circle.dart';
import 'package:survly/widgets/app_map_card_widget.dart';

class ResponseUserSurveyScreen extends StatelessWidget {
  const ResponseUserSurveyScreen({
    super.key,
    required this.surveyId,
    required this.doSurveyId,
  });

  final String surveyId;
  final String doSurveyId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResponseUserSurveyBloc(surveyId, doSurveyId),
      child: BlocBuilder<ResponseUserSurveyBloc, ResponseUserSurveyState>(
        buildWhen: (previous, current) =>
            previous.doSurvey != current.doSurvey ||
            previous.questionList != current.questionList,
        builder: (context, state) {
          return Scaffold(
            appBar: const AppAppBarWidget(
              noActionBar: true,
            ),
            resizeToAvoidBottomInset: false,
            body: state.doSurvey == null || state.questionList.isEmpty
                ? const AppLoadingCircle()
                : _buildSurveyForm(),
          );
        },
      ),
    );
  }

  Widget _buildSurveyForm() {
    return BlocBuilder<ResponseUserSurveyBloc, ResponseUserSurveyState>(
      buildWhen: (previous, current) =>
          previous.currentPage != current.currentPage,
      builder: (context, state) {
        return Column(
          children: [
            Container(
              width: double.infinity,
              color: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      context
                          .read<ResponseUserSurveyBloc>()
                          .goPreviousPage(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new),
                    color: AppColors.onPrimary,
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      S.of(context).labelPage(
                            state.currentPage + 1,
                            state.questionList.length + 2,
                          ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      context
                          .read<ResponseUserSurveyBloc>()
                          .goNextPage(context);
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: state.getPageType == PageType.intro
                  ? _buildIntro(context, state)
                  : state.getPageType == PageType.question
                      ? _buildQuestion(context, state)
                      : _buildOutlet(context, state),
            ),
            state.isResponsed
                ? _buildStatus(state)
                : _buildResponseButton(context, state)
          ],
        );
      },
    );
  }

  Widget _buildQuestion(BuildContext context, ResponseUserSurveyState state) {
    int questionPosition = state.currentPage - 1;
    Question question = state.questionList[questionPosition];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: question.questionType == QuestionType.text.value
          ? QuestionTextWidget(
              question: question,
              onAnswerChanged: (answer) {},
              answer: state.answerList[questionPosition].first,
              readOnly: true,
            )
          : question.questionType == QuestionType.singleOption.value
              ? QuestionSingleOptionWidget(
                  question: question as QuestionWithOption,
                  answer: state.answerList[questionPosition].firstOrNull ?? "",
                  onAnswerChanged: (option) {},
                  readOnly: true,
                )
              : QuestionMultiOptionWidget(
                  question: question as QuestionWithOption,
                  answers: state.answerList[questionPosition],
                  onAnswerChanged: (option) {},
                  readOnly: true,
                ),
    );
  }

  Widget _buildIntro(BuildContext context, ResponseUserSurveyState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(
          state.survey?.thumbnail ?? "",
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.survey?.title ?? "",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(state.survey?.description ?? ""),
              const SizedBox(height: 8),
              Text(S.of(context).hintGoToOutletPlace),
              const SizedBox(height: 8),
              AppMapCardWidget(
                locationCoordinate: LatLng(
                  state.survey!.outlet!.latitude!,
                  state.survey!.outlet!.longitude!,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildOutlet(BuildContext context, ResponseUserSurveyState state) {
    return Column(
      children: [
        const SizedBox(
          height: 16,
        ),
        Text(
          S.of(context).hintTakePhotoOutlet,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        AppImagePicker(
          imagePath: "",
          defaultImageUrl: state.doSurvey?.photoOutlet,
          flexibleSize: true,
          onPickImage: () {},
        )
      ],
    );
  }

  Widget _buildResponseButton(
    BuildContext context,
    ResponseUserSurveyState state,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: ResponseButtonWidget(
              labelText: S.of(context).labelBtnIgnore,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (buildDialog) {
                    return AppDialog(
                      title: S.of(context).dialogTitleIgnoreSurvey,
                      body: S.of(context).dialogBodyIgnoreSurvey,
                      onCancelPressed: () {},
                      onConfirmPressed: () {
                        context.read<ResponseUserSurveyBloc>().ignoreSurvey();
                      },
                    );
                  },
                );
              },
              themeColor: AppColors.negative,
            ),
          ),
          if (state.getPageType == PageType.outlet) ...[
            const SizedBox(
              width: 8,
            ),
            Expanded(
              flex: 1,
              child: ResponseButtonWidget(
                labelText: S.of(context).labelBtnApprove,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (buildDialog) {
                      return AppDialog(
                        title: S.of(context).dialogTitleApproveSurvey,
                        body: S.of(context).dialogBodyApproveSurvey,
                        onCancelPressed: () {},
                        onConfirmPressed: () {
                          context
                              .read<ResponseUserSurveyBloc>()
                              .approveSurvey();
                        },
                      );
                    },
                  );
                },
                themeColor: AppColors.positive,
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildStatus(ResponseUserSurveyState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[200],
      child: Center(
        child: Text(
          state.doSurvey!.status.toUpperCase(),
          style: const TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
