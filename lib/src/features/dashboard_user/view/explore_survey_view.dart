import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:survly/src/features/dashboard_user/logic/explore_survey_bloc.dart';
import 'package:survly/src/features/dashboard_user/logic/explore_survey_state.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/router/router_name.dart';
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
                      suffixIcon: IconButton(
                        onPressed: () {
                          context.read<ExploreSurveyBloc>().searchSurvey();
                        },
                        icon: const Icon(Icons.search),
                      ),
                      onTextChange: (newText) {
                        context
                            .read<ExploreSurveyBloc>()
                            .onSearchKeywordChange(newText);
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (sheetContext) {
                          return _buildBottomSheetFilter(context);
                        },
                      );
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
              child: AppSurveyListWidget(
                surveyList: state.surveyFilterList,
                onRefresh: () =>
                    context.read<ExploreSurveyBloc>().fetchFirstPageSurvey(),
                onLoadMore: () =>
                    context.read<ExploreSurveyBloc>().fetchMoreSurvey(),
                onItemClick: (survey) {
                  context.push(AppRouteNames.previewSurvey.path, extra: survey);
                },
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildBottomSheetFilter(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<ExploreSurveyBloc>(context),
      child: BlocBuilder<ExploreSurveyBloc, ExploreSurveyState>(
        buildWhen: (previous, current) =>
            previous.isShowSurveyNearby != current.isShowSurveyNearby,
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, -1),
                  blurRadius: 8,
                ),
              ],
              color: Colors.grey[200],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Text(
                        S.of(context).labelShowOnlyNearbySurvey,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Switch(
                        value: state.isShowSurveyNearby,
                        onChanged: (value) {
                          context
                              .read<ExploreSurveyBloc>()
                              .showSurveyNearbyChanged(value);
                        },
                      )
                    ],
                  ),
                ),
                const Divider(height: 0)
              ],
            ),
          );
        },
      ),
    );
  }
}
