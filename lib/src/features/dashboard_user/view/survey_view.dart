import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:survly/src/features/dashboard_user/logic/survey_list_bloc.dart';
import 'package:survly/src/features/dashboard_user/logic/survey_list_state.dart';
import 'package:survly/src/features/dashboard_user/widget/survey_list_widget.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/src/router/router_name.dart';
import 'package:survly/widgets/app_loading_circle.dart';
import 'package:survly/widgets/app_text_field.dart';

class ExploreView extends StatelessWidget {
  const ExploreView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => SurveyListBloc(),
      child: BlocBuilder<SurveyListBloc, SurveyListState>(
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
                  Expanded(
                    flex: 1,
                    child: AppTextField(
                      hintText: S.of(context).labelSearch,
                      prefixIcon: const Icon(Icons.search),
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
              child: SurveyListWidget(
                surveyList: state.surveyFilterList,
                onRefresh: () =>
                    context.read<SurveyListBloc>().fetchFirstPageSurvey(),
                onLoadMore: () =>
                    context.read<SurveyListBloc>().fetchMoreSurvey(),
                onItemClick: (survey) async {
                  await context
                      .push(AppRouteNames.reviewSurvey.path, extra: survey)
                      .then(
                    (value) {
                      if (value != null) {
                        if (value == true) {
                          // is archived
                          context.read<SurveyListBloc>().archiveSurvey(survey);
                        } else {
                          // is updated
                          context
                              .read<SurveyListBloc>()
                              .onSurveyListItemChange(survey, value as Survey);
                        }
                      }
                    },
                  );
                },
              ),
            )
          ],
        );
      },
    );
  }
}