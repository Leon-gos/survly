import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/features/do_survey/logic/do_survey_bloc.dart';
import 'package:survly/src/features/do_survey/logic/do_survey_state.dart';
import 'package:survly/src/features/do_survey/widget/question_multi_option_widget.dart';
import 'package:survly/src/features/do_survey/widget/question_single_option_widget.dart';
import 'package:survly/src/features/do_survey/widget/question_text_widget.dart';
import 'package:survly/src/network/model/question/question.dart';
import 'package:survly/src/network/model/question/question_with_options.dart';
import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/src/theme/colors.dart';
import 'package:survly/widgets/app_app_bar.dart';
import 'package:survly/widgets/app_loading_circle.dart';

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
        buildWhen: (previous, current) => previous.doSurvey != current.doSurvey,
        builder: (context, state) {
          return Scaffold(
            appBar: const AppAppBarWidget(
              noActionBar: true,
            ),
            body: state.doSurvey == null
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
          previous.doSurvey != current.doSurvey ||
          previous.questionList != current.questionList ||
          previous.currentPage != current.currentPage,
      builder: (context, state) {
        return Column(
          children: [
            Container(
              width: double.infinity,
              // height: 100,
              color: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      context.read<DoSurveyBloc>().goPreviousPage();
                    },
                    icon: const Icon(Icons.arrow_back_ios_new),
                    color: AppColors.onPrimary,
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "Page ${state.currentPage}",
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
                      context.read<DoSurveyBloc>().goNextPage();
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
              child: state.getPageType == PageType.intro
                  ? _buildIntro(context, state)
                  : state.getPageType == PageType.question
                      ? _buildQuestion(context, state)
                      : _buildOutlet(context, state),
            )
          ],
        );
      },
    );
  }

  Widget _buildQuestion(BuildContext context, DoSurveyState state) {
    Logger().d("build quest");
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
        Text(state.survey.title),
        Text(state.survey.description),
      ],
    );
  }

  Widget _buildOutlet(BuildContext context, DoSurveyState state) {
    return SizedBox();
  }
}
