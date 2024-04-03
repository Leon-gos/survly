import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/src/features/dashboard/logic/survey_list_bloc.dart';
import 'package:survly/src/features/dashboard/logic/survey_list_state.dart';
import 'package:survly/src/features/dashboard/widget/survey_card.dart';
import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/widgets/app_loading_circle.dart';
import 'package:survly/widgets/app_text_field.dart';

class SurveyView extends StatelessWidget {
  const SurveyView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SurveyListBloc(),
      child: BlocBuilder<SurveyListBloc, SurveyListState>(
        buildWhen: (previous, current) {
          return (previous.surveyList != current.surveyList) ||
              (previous.isShowMySurvey != current.isShowMySurvey);
        },
        builder: (context, state) {
          return Scaffold(
            body: state.surveyList.isEmpty
                ? const AppLoadingCircle()
                : _buildSurveyListView(context, state),
          );
        },
      ),
    );
  }

  Widget _buildSurveyListView(BuildContext context, SurveyListState state) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            children: [
              const Expanded(
                flex: 1,
                child: AppTextField(
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              IconButton(
                onPressed: () {
                  context
                      .read<SurveyListBloc>()
                      .filterSurveyList(!state.isShowMySurvey);
                },
                icon: const Icon(
                  Icons.filter_alt_outlined,
                  color: Colors.grey,
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: _buildSurveyList(
            state.isShowMySurvey ? state.mySurveyList : state.surveyList,
          ),
        )
      ],
    );
  }

  Widget _buildSurveyList(List<Survey> surveyList) {
    return ListView.builder(
      itemCount: surveyList.length,
      itemBuilder: (context, index) {
        return SurveyCard(
          survey: surveyList[index],
        );
      },
    );
  }
}
