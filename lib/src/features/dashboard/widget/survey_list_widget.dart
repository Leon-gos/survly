import 'package:flutter/material.dart';
import 'package:survly/src/features/dashboard/widget/survey_card.dart';
import 'package:survly/src/network/model/survey/survey.dart';

class SurveyListWidget extends StatefulWidget {
  final List<Survey> surveyList;
  final Function()? onLoadMore;
  final Function()? onRefresh;

  const SurveyListWidget({
    super.key,
    required this.surveyList,
    this.onLoadMore,
    this.onRefresh,
  });

  @override
  State<StatefulWidget> createState() => _SurveyListWidgetState();
}

class _SurveyListWidgetState extends State<SurveyListWidget> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(
      () {
        if (scrollController.offset >=
                scrollController.position.maxScrollExtent &&
            !scrollController.position.outOfRange &&
            scrollController.position.axisDirection == AxisDirection.down) {
          widget.onLoadMore?.call();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        widget.onRefresh?.call();
      },
      child: ListView.builder(
        controller: scrollController,
        itemCount: widget.surveyList.length,
        itemBuilder: (context, index) {
          return SurveyCard(
            survey: widget.surveyList[index],
          );
        },
      ),
    );
  }
}
