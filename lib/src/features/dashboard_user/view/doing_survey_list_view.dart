import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:survly/src/features/dashboard_user/logic/doing_survey_list_bloc.dart';
import 'package:survly/src/features/dashboard_user/logic/doing_survey_list_state.dart';
import 'package:survly/src/features/dashboard_user/widget/doing_survey_list_widget.dart';
import 'package:survly/src/router/router_name.dart';
import 'package:survly/widgets/app_loading_circle.dart';

class DoingSurveyListView extends StatelessWidget {
  const DoingSurveyListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => DoingSurveyListBloc(),
      child: BlocBuilder<DoingSurveyListBloc, DoingSurveyListState>(
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
    return BlocBuilder<DoingSurveyListBloc, DoingSurveyListState>(
      buildWhen: (previous, current) =>
          previous.surveyList != current.surveyList,
      builder: (context, state) {
        return DoingSurveyListWidget(
          surveyList: state.surveyList,
          onRefresh: () =>
              context.read<DoingSurveyListBloc>().fetchAllDoingSurvey(),
          onItemClick: (survey) {
            context
                .push(AppRouteNames.doSurvey.path, extra: survey)
                .then((value) {
              if (value == true) {
                context.read<DoingSurveyListBloc>().fetchAllDoingSurvey();
              }
            });
          },
        );
      },
    );
  }
}
