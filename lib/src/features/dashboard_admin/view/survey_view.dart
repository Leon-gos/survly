import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:survly/src/features/dashboard_admin/logic/survey_list_bloc.dart';
import 'package:survly/src/features/dashboard_admin/logic/survey_list_state.dart';
import 'package:survly/widgets/app_survey_list_widget.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/src/router/router_name.dart';
import 'package:survly/widgets/app_loading_circle.dart';
import 'package:survly/widgets/app_text_field.dart';

class SurveyView extends StatelessWidget {
  const SurveyView({super.key});

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
          previous.surveyFilterList != current.surveyFilterList ||
          previous.isShowingFilterSheet != current.isShowingFilterSheet,
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
                          context.read<SurveyListBloc>().searchSurvey();
                        },
                        icon: const Icon(Icons.search),
                      ),
                      onTextChange: (newText) {
                        context
                            .read<SurveyListBloc>()
                            .onSearchKeywordChange(newText);
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (state.isShowingFilterSheet) {
                        return;
                      }
                      context
                          .read<SurveyListBloc>()
                          .onShowingFilterSheetChange(true);
                      showBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(),
                        builder: (sheetContext) {
                          return _buildBottomSheetFilter();
                        },
                      ).closed.then((value) {
                        context
                            .read<SurveyListBloc>()
                            .onShowingFilterSheetChange(false);
                      });
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

  Widget _buildBottomSheetFilter() {
    return BlocBuilder<SurveyListBloc, SurveyListState>(
      buildWhen: (previous, current) =>
          previous.isShowMySurvey != current.isShowMySurvey ||
          previous.filterByStatus != current.filterByStatus,
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
                      S.of(context).labelShowOnlyMySurvey,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Switch(
                      value: state.isShowMySurvey,
                      onChanged: (value) {
                        context.read<SurveyListBloc>().showOnlyMySurvey(value);
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).labelSurveyStatus,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    RadioListTile(
                      title: Text(S.of(context).labelStatusAll),
                      value: FilterByStatus.all,
                      groupValue: state.filterByStatus,
                      onChanged: (value) {
                        context
                            .read<SurveyListBloc>()
                            .filterBySurveyStatus(value);
                      },
                    ),
                    RadioListTile(
                      title: Text(S.of(context).labelStatusPublic),
                      value: FilterByStatus.public,
                      groupValue: state.filterByStatus,
                      onChanged: (value) {
                        context
                            .read<SurveyListBloc>()
                            .filterBySurveyStatus(value);
                      },
                    ),
                    RadioListTile(
                      title: Text(S.of(context).labelStatusDraft),
                      value: FilterByStatus.draft,
                      groupValue: state.filterByStatus,
                      onChanged: (value) {
                        context
                            .read<SurveyListBloc>()
                            .filterBySurveyStatus(value);
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Material(
                child: InkWell(
                  onTap: () {
                    context.pop();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                        child: Text(
                      S.of(context).labelBtnClose,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ),
                ),
              ),
              const Divider(height: 0)
            ],
          ),
        );
      },
    );
  }
}
