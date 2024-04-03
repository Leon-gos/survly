import 'package:flutter/material.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/dashboard/widget/survey_card.dart';
import 'package:survly/src/localization/localization_utils.dart';

class SurveyView extends StatelessWidget {
  const SurveyView({super.key});

  @override
  Widget build(BuildContext context) {
    DomainManager().survey.fetchAllSurvey();
    return Scaffold(
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return const SurveyCard();
        },
      ),
    );
  }
}
