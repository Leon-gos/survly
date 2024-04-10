import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/src/features/survey_request/logic/survey_request_bloc.dart';
import 'package:survly/src/features/survey_request/logic/survey_request_state.dart';
import 'package:survly/src/features/survey_request/widget/request_card.dart';
import 'package:survly/widgets/app_app_bar.dart';

class SurveyRequestScreen extends StatelessWidget {
  const SurveyRequestScreen({super.key, this.surveyId});

  final String? surveyId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SurveyRequestBloc(surveyId),
      child: BlocBuilder<SurveyRequestBloc, SurveyRequestState>(
        builder: (context, state) {
          return Scaffold(
            appBar: const AppAppBarWidget(
              title: "Request list",
            ),
            body: _buildRequestList(),
          );
        },
      ),
    );
  }

  Widget _buildRequestList() {
    return BlocBuilder<SurveyRequestBloc, SurveyRequestState>(
      builder: (context, state) {
        return ListView.builder(
          itemCount: state.surveyRequestList.length,
          itemBuilder: (context, index) {
            var request = state.surveyRequestList[index];
            return Container(
              margin: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: RequestCard(request: request),
            );
          },
        );
      },
    );
  }
}
