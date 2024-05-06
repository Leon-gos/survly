import 'package:flutter/material.dart';
import 'package:survly/src/features/dashboard_user/widget/explore_survey_card.dart';
import 'package:survly/widgets/app_empty_list_widget.dart';
import 'package:survly/src/network/model/survey/survey.dart';

class ExploreSurveyListWidget extends StatefulWidget {
  final List<Survey> surveyList;
  final Future<void> Function()? onLoadMore;
  final Function()? onRefresh;
  final Function(Survey survey)? onItemClick;

  const ExploreSurveyListWidget({
    super.key,
    required this.surveyList,
    this.onLoadMore,
    this.onRefresh,
    this.onItemClick,
  });

  @override
  State<StatefulWidget> createState() => _ExploreSurveyListWidgetState();
}

class _ExploreSurveyListWidgetState extends State<ExploreSurveyListWidget> {
  final scrollController = ScrollController();
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(
      () async {
        if (scrollController.offset >=
                scrollController.position.maxScrollExtent &&
            !scrollController.position.outOfRange &&
            scrollController.position.axisDirection == AxisDirection.down) {
          setState(() {
            isLoadingMore = true;
          });
          await widget.onLoadMore?.call();
          setState(() {
            isLoadingMore = false;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        widget.onRefresh?.call();
      },
      child: Stack(
        children: [
          if (widget.surveyList.isEmpty) const AppEmptyListWidget(),
          Column(
            children: [
              Expanded(
                flex: 1,
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: scrollController,
                  itemCount: widget.surveyList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        widget.onItemClick?.call(widget.surveyList[index]);
                      },
                      child: ExploreSurveyCard(
                        survey: widget.surveyList[index],
                      ),
                    );
                  },
                ),
              ),
              isLoadingMore
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: CircularProgressIndicator(),
                    )
                  : const SizedBox(),
            ],
          )
        ],
      ),
    );
  }
}
