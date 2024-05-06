import 'package:flutter/material.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/src/theme/colors.dart';
import 'package:survly/src/utils/date_helper.dart';
import 'package:survly/src/utils/number_helper.dart';

class ExploreSurveyCard extends StatelessWidget {
  const ExploreSurveyCard({
    super.key,
    required this.survey,
    this.borderRadius = 8,
  });

  final double borderRadius;
  final Survey survey;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          boxShadow: const [
            BoxShadow(
              blurRadius: 2,
              color: Colors.black26,
              offset: Offset(0, 0),
            )
          ],
          color: AppColors.white),
      child: Column(
        children: [
          _buildSurveyThumbnail(),
          _buildSurveyContent(context),
        ],
      ),
    );
  }

  Widget _buildSurveyThumbnail() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(borderRadius),
        topRight: Radius.circular(borderRadius),
      ),
      child: survey.thumbnail != ""
          ? Image.network(
              survey.thumbnail,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            )
          : Container(
              width: double.infinity,
              height: 200,
              color: Colors.grey,
            ),
    );
  }

  Widget _buildSurveyContent(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            survey.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                        "${survey.respondentNum}/${survey.respondentMax} ${S.of(context).respondent}"),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                        "${S.of(context).labelStartedOn} ${DateHelper.getDateOnly(survey.dateStart)}"),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius:
                        BorderRadius.all(Radius.circular(borderRadius))),
                child: Text(
                  NumberHelper.formatCurrency(survey.cost),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors.white),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}