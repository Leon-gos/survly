import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/src/features/do_survey/logic/do_survey_bloc.dart';
import 'package:survly/src/features/do_survey/logic/do_survey_state.dart';
import 'package:survly/src/network/model/do_survey/do_survey.dart';

// Test only
// TODO: do later
class DoSurveyScreen extends StatelessWidget {
  const DoSurveyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DoSurveyBloc(
        DoSurvey(
          doSurveyId: "Ermd203XOKlrg1A1QdWu",
          status: "",
        ),
      ),
      child: BlocBuilder<DoSurveyBloc, DoSurveyState>(
        buildWhen: (previous, current) => previous.doSurvey != current.doSurvey,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Column(
              children: [
                Text("Lat: ${state.doSurvey.currentLat}"),
                Text("Long: ${state.doSurvey.currentLng}"),
              ],
            ),
          );
        },
      ),
    );
  }
}
