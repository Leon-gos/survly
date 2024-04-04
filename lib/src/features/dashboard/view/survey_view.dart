import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/src/features/dashboard/logic/survey_list_bloc.dart';
import 'package:survly/src/features/dashboard/logic/survey_list_state.dart';
import 'package:survly/src/features/dashboard/widget/survey_card.dart';
import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/widgets/app_loading_circle.dart';
import 'package:survly/widgets/app_text_field.dart';

class SurveyView extends StatelessWidget {
  SurveyView({super.key});
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SurveyListBloc(),
      child: BlocBuilder<SurveyListBloc, SurveyListState>(
        buildWhen: (previous, current) {
          return previous.isLoading != current.isLoading;
        },
        builder: (context, state) {
          scrollController.addListener(
            () {
              if (scrollController.offset >=
                      scrollController.position.maxScrollExtent &&
                  !scrollController.position.outOfRange &&
                  scrollController.position.axisDirection ==
                      AxisDirection.down) {
                context.read<SurveyListBloc>().fetchMoreSurvey();
              }
            },
          );
          return Scaffold(
            body: state.isLoading
                ? const AppLoadingCircle()
                : _buildSurveyListView(),
          );
        },
      ),
    );
  }

  Widget _buildSurveyListView() {
    return BlocBuilder<SurveyListBloc, SurveyListState>(
      buildWhen: (previous, current) =>
          previous.isShowMySurvey != current.isShowMySurvey ||
          previous.surveyFilterList != current.surveyFilterList,
      builder: (context, state) {
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
                    icon: Icon(
                      state.isShowMySurvey
                          ? Icons.filter_alt
                          : Icons.filter_alt_outlined,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: _buildSurveyList(
                state.surveyFilterList,
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildSurveyList(List<Survey> surveyList) {
    return ListView.builder(
      controller: scrollController,
      itemCount: surveyList.length,
      itemBuilder: (context, index) {
        return SurveyCard(
          survey: surveyList[index],
        );
      },
    );
  }
}
