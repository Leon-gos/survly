import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:survly/src/features/survey_response/logic/survey_response_bloc.dart';
import 'package:survly/src/features/survey_response/logic/survey_response_state.dart';
import 'package:survly/src/features/survey_response/widget/response_card.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/src/router/router_name.dart';
import 'package:survly/widgets/app_app_bar.dart';
import 'package:survly/widgets/app_loading_circle.dart';

class SurveyResponseScreen extends StatelessWidget {
  const SurveyResponseScreen({super.key, required this.survey});

  final Survey survey;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SurveyResponseBloc(survey),
      child: BlocBuilder<SurveyResponseBloc, SurveyResponseState>(
        buildWhen: (previous, current) =>
            previous.isLoading != current.isLoading,
        builder: (context, state) {
          return Scaffold(
            appBar: AppAppBarWidget(
              title: S.of(context).titleRespondentList,
            ),
            body: state.isLoading
                ? const Center(
                    child: AppLoadingCircle(),
                  )
                : _buildResponseList(context, state),
          );
        },
      ),
    );
  }

  Widget _buildResponseList(BuildContext context, SurveyResponseState state) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 32),
      itemCount: state.surveyResponseList.length,
      itemBuilder: (context, index) {
        var response = state.surveyResponseList[index];
        return Container(
          margin: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
          ),
          child: GestureDetector(
            onTap: () async {
              List<Object> extra = [state.survey, response];
              await context
                  .push(AppRouteNames.responseUserSurvey.path, extra: extra)
                  .then((value) {
                if (value != null) {
                  context
                      .read<SurveyResponseBloc>()
                      .fetchResponseList(state.survey.surveyId);
                }
              });
            },
            child: ResponseCard(response: response),
          ),
        );
      },
    );
  }
}
