import 'package:flutter/material.dart';
import 'package:survly/src/features/dashboard_admin/widget/survey_card.dart';
import 'package:survly/src/network/model/survey/survey.dart';

class SurveyListWidget extends StatefulWidget {
  final List<Survey> surveyList;
  final Future<void> Function()? onLoadMore;
  final Function()? onRefresh;
  final Function(Survey survey)? onItemClick;

  const SurveyListWidget({
    super.key,
    required this.surveyList,
    this.onLoadMore,
    this.onRefresh,
    this.onItemClick,
  });

  @override
  State<StatefulWidget> createState() => _SurveyListWidgetState();
}

class _SurveyListWidgetState extends State<SurveyListWidget> {
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
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 50),
              physics: const AlwaysScrollableScrollPhysics(),
              controller: scrollController,
              itemCount: widget.surveyList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    widget.onItemClick?.call(widget.surveyList[index]);
                  },
                  child: SurveyCard(
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
      ),
    );
  }
}
