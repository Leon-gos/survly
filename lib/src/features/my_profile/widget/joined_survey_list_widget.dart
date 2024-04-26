import 'package:flutter/material.dart';
import 'package:survly/src/features/my_profile/widget/joined_survey_card.dart';
import 'package:survly/src/network/model/do_survey/do_survey.dart';
import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/widgets/app_empty_list_widget.dart';

class JoinedSurveyListWidget extends StatefulWidget {
  final List<Survey> surveyList;
  final List<DoSurvey> doSurveyList;
  final Future<void> Function()? onLoadMore;
  final Function()? onRefresh;
  final Function(Survey survey)? onItemClick;

  const JoinedSurveyListWidget({
    super.key,
    required this.surveyList,
    required this.doSurveyList,
    this.onLoadMore,
    this.onRefresh,
    this.onItemClick,
  });

  @override
  State<StatefulWidget> createState() => _DoingSurveyListWidgetState();
}

class _DoingSurveyListWidgetState extends State<JoinedSurveyListWidget> {
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
          if (widget.surveyList.isEmpty ||
              widget.surveyList.length != widget.doSurveyList.length)
            const AppEmptyListWidget(),
          Column(
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
                      child: JoinedSurveyCard(
                        survey: widget.surveyList[index],
                        doSurvey: widget.doSurveyList[index],
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
