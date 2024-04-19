import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:survly/src/features/do_survey/logic/do_survey_bloc.dart';
import 'package:survly/src/features/do_survey/logic/do_survey_state.dart';
import 'package:survly/src/features/do_survey/widget/question_multi_option_widget.dart';
import 'package:survly/src/features/do_survey/widget/question_single_option_widget.dart';
import 'package:survly/src/features/do_survey/widget/question_text_widget.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/model/question/question.dart';
import 'package:survly/src/network/model/question/question_with_options.dart';
import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/src/theme/colors.dart';
import 'package:survly/widgets/app_app_bar.dart';
import 'package:survly/widgets/app_image_picker.dart';
import 'package:survly/widgets/app_loading_circle.dart';
import 'package:survly/widgets/app_map_card_widget.dart';

class DoSurveyScreen extends StatelessWidget {
  const DoSurveyScreen({
    super.key,
    required this.survey,
  });

  final Survey survey;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DoSurveyBloc(survey),
      child: BlocBuilder<DoSurveyBloc, DoSurveyState>(
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
    return BlocBuilder<DoSurveyBloc, DoSurveyState>(
      buildWhen: (previous, current) =>
          previous.currentPage != current.currentPage ||
          previous.outletPath != current.outletPath,
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
                      context.read<DoSurveyBloc>().goPreviousPage(context);
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
                      context.read<DoSurveyBloc>().goNextPage(context);
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  context
                      .read<DoSurveyBloc>()
                      .onSaveDraftSurveyBtnPressed(context);
                },
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  backgroundColor:
                      const MaterialStatePropertyAll(AppColors.secondary),
                ),
                child: Text(
                  S.of(context).labelBtnSaveDraft,
                  style: const TextStyle(color: AppColors.white),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildQuestion(BuildContext context, DoSurveyState state) {
    int questionPosition = state.currentPage - 1;
    Question question = state.questionList[questionPosition];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: question.questionType == QuestionType.text.value
          ? QuestionTextWidget(
              question: question,
              onAnswerChanged: (answer) {
                context.read<DoSurveyBloc>().onAnswer(questionPosition, answer);
              },
              answer: state.answerList[questionPosition].first,
            )
          : question.questionType == QuestionType.singleOption.value
              ? QuestionSingleOptionWidget(
                  question: question as QuestionWithOption,
                  answer: state.answerList[questionPosition].firstOrNull ?? "",
                  onAnswerChanged: (option) {
                    context
                        .read<DoSurveyBloc>()
                        .onAnswer(questionPosition, option);
                  },
                )
              : QuestionMultiOptionWidget(
                  question: question as QuestionWithOption,
                  answers: state.answerList[questionPosition],
                  onAnswerChanged: (option) {
                    context
                        .read<DoSurveyBloc>()
                        .onAnswer(questionPosition, option);
                  },
                ),
    );
  }

  Widget _buildIntro(BuildContext context, DoSurveyState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(
          state.survey.thumbnail,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.survey.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(state.survey.description),
              const SizedBox(height: 8),
              const Text("Go to the place below and do this survey:"),
              const SizedBox(height: 8),
              AppMapCardWidget(
                locationCoordinate: LatLng(
                  state.survey.outlet!.latitude!,
                  state.survey.outlet!.longitude!,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildOutlet(BuildContext context, DoSurveyState state) {
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
          imagePath: state.outletPath,
          defaultImageUrl: state.doSurvey?.photoOutlet,
          flexibleSize: true,
          onPickImage: () {
            context.read<DoSurveyBloc>().onTakeOutletPhoto();
          },
        )
      ],
    );
  }
}
