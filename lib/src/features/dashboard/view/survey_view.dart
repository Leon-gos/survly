import 'package:flutter/material.dart';
import 'package:survly/src/localization/localization_utils.dart';

class SurveyView extends StatelessWidget {
  const SurveyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(S.of(context).labelSurvey),
      ),
    );
  }

}