import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/src/features/dashboard/logic/survey_list_bloc.dart';
import 'package:survly/src/features/dashboard/logic/survey_list_state.dart';
import 'package:survly/src/features/dashboard/widget/survey_card.dart';
import 'package:survly/widgets/app_loading_circle.dart';

class SurveyView extends StatelessWidget {
  const SurveyView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SurveyListBloc(),
      child: BlocBuilder<SurveyListBloc, SurveyListState>(
        builder: (context, state) {
          return Scaffold(
            body: state.surveyList.isEmpty
                ? const AppLoadingCircle()
                : ListView.builder(
                    itemCount: state.surveyList.length,
                    itemBuilder: (context, index) {
                      return SurveyCard(
                        survey: state.surveyList[index],
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
