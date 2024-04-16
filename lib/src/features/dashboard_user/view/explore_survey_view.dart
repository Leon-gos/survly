import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/src/features/dashboard_user/logic/explore_survey_bloc.dart';
import 'package:survly/src/features/dashboard_user/logic/explore_survey_state.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/widgets/app_loading_circle.dart';
import 'package:survly/widgets/app_survey_list_widget.dart';
import 'package:survly/widgets/app_text_field.dart';

class ExploreSurveyView extends StatelessWidget {
  const ExploreSurveyView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => ExploreSurveyBloc(),
      child: BlocBuilder<ExploreSurveyBloc, ExploreSurveyState>(
        buildWhen: (previous, current) {
          return previous.isLoading != current.isLoading;
        },
        builder: (context, state) {
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
    return BlocBuilder<ExploreSurveyBloc, ExploreSurveyState>(
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
                  Expanded(
                    flex: 1,
                    child: AppTextField(
                      hintText: S.of(context).labelSearch,
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
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
              child: AppSurveyListWidget(
                surveyList: state.surveyFilterList,
                onRefresh: () =>
                    context.read<ExploreSurveyBloc>().fetchFirstPageSurvey(),
                onLoadMore: () =>
                    context.read<ExploreSurveyBloc>().fetchMoreSurvey(),
                onItemClick: (survey) {},
              ),
            )
          ],
        );
      },
    );
  }
}
