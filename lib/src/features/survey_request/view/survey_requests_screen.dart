import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/src/features/survey_request/logic/survey_request_bloc.dart';
import 'package:survly/src/features/survey_request/logic/survey_request_state.dart';
import 'package:survly/src/features/survey_request/widget/request_card.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/src/network/model/survey_request/survey_request.dart';
import 'package:survly/widgets/app_app_bar.dart';
import 'package:survly/widgets/app_dialog.dart';
import 'package:survly/widgets/app_loading_circle.dart';

class SurveyRequestScreen extends StatelessWidget {
  const SurveyRequestScreen({super.key, required this.survey});

  final Survey survey;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SurveyRequestBloc(survey),
      child: BlocBuilder<SurveyRequestBloc, SurveyRequestState>(
        buildWhen: (previous, current) =>
            previous.isLoading != current.isLoading,
        builder: (context, state) {
          return Scaffold(
            appBar: AppAppBarWidget(
              title: S.of(context).titleRequestList,
            ),
            body: state.isLoading
                ? const Center(
                    child: AppLoadingCircle(),
                  )
                : _buildRequestList(),
          );
        },
      ),
    );
  }

  Widget _buildRequestList() {
    return BlocBuilder<SurveyRequestBloc, SurveyRequestState>(
      builder: (context, state) {
        if (state.survey.ableToResponseRequest(
          UserBaseSingleton.instance().userBase?.id,
        )) {
          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 32),
            itemCount: state.surveyRequestList.length,
            itemBuilder: (context, index) {
              var request = state.surveyRequestList[index];
              return Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                child: RequestCard(
                  request: request,
                  onAccept: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) {
                        return AppDialog(
                          title: S.of(context).dialogTitleAcceptRequest,
                          body: S.of(context).dialogBodyAcceptRequest,
                          onConfirmPressed: () {
                            context.read<SurveyRequestBloc>().reponseRequest(
                                request, SurveyRequestStatus.accepted);
                          },
                          onCancelPressed: () {},
                        );
                      },
                    );
                  },
                  onDeny: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) {
                        return AppDialog(
                          title: S.of(context).dialogTitleDenyRequest,
                          body: S.of(context).dialogBodyDenyRequest,
                          onConfirmPressed: () {
                            context.read<SurveyRequestBloc>().reponseRequest(
                                request, SurveyRequestStatus.denied);
                          },
                          onCancelPressed: () {},
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 32),
          itemCount: state.surveyRequestList.length,
          itemBuilder: (context, index) {
            var request = state.surveyRequestList[index];
            return Container(
              margin: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: RequestCard(request: request),
            );
          },
        );
      },
    );
  }
}
