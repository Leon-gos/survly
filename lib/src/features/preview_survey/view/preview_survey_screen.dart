import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:survly/src/features/preview_survey/logic/preview_survey_bloc.dart';
import 'package:survly/src/features/preview_survey/logic/preview_survey_state.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/src/network/model/survey_request/survey_request.dart';
import 'package:survly/src/theme/colors.dart';
import 'package:survly/src/utils/number_helper.dart';
import 'package:survly/widgets/app_app_bar.dart';
import 'package:survly/widgets/app_dialog.dart';
import 'package:survly/widgets/app_text_field.dart';

class PreviewSurveyScreen extends StatelessWidget {
  const PreviewSurveyScreen({
    super.key,
    required this.survey,
  });

  final Survey survey;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PreviewSurveyBloc(survey),
      child: Scaffold(
        appBar: AppAppBarWidget(
          title: S.of(context).titlePreviewSurvey,
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.share),
              color: Colors.white,
            )
          ],
        ),
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: _buildSurveyPreview(),
            ),
            _buildRequestButton()
          ],
        ),
      ),
    );
  }

  Widget _buildSurveyPreview() {
    return BlocBuilder<PreviewSurveyBloc, PreviewSurveyState>(
      buildWhen: (previous, current) =>
          previous.survey != current.survey ||
          previous.numQuestion != current.numQuestion,
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Image.network(
                state.survey.thumbnail,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      state.survey.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(state.survey.description),
                    const SizedBox(height: 8),
                    Text(
                      S.of(context).labelSurveyNumQuestion(state.numQuestion),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${S.of(context).hintDateFrom} ${state.survey.dateStart} ${S.of(context).hintDateTo} ${state.survey.dateEnd}",
                    ),
                    const SizedBox(height: 8),
                    Text(
                      S.of(context).labelSurveyEarn(
                          NumberHelper.formatCurrency(state.survey.cost)),
                    ),
                    const SizedBox(height: 8),
                    Text(
                        "${S.of(context).hintOutlet} ${survey.outlet?.address}"),
                    const SizedBox(height: 8),
                    if (state.survey.outlet != null &&
                        state.survey.outlet!.hasCoordinate())
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 2,
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: GoogleMap(
                            scrollGesturesEnabled: false,
                            rotateGesturesEnabled: false,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                state.survey.outlet!.latitude!,
                                state.survey.outlet!.longitude!,
                              ),
                              zoom: 15,
                            ),
                            markers: {
                              Marker(
                                  markerId: const MarkerId("place"),
                                  position: LatLng(
                                    state.survey.outlet!.latitude!,
                                    state.survey.outlet!.longitude!,
                                  ))
                            },
                          ),
                        ),
                      )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildRequestButton() {
    return BlocBuilder<PreviewSurveyBloc, PreviewSurveyState>(
      buildWhen: (previous, current) =>
          previous.latestRequest != current.latestRequest,
      builder: (context, state) {
        if (state.latestRequest?.status == SurveyRequestStatus.accepted.value) {
          return const SizedBox();
        }
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          width: double.infinity,
          child: Theme(
            data: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: state.latestRequest?.status ==
                        SurveyRequestStatus.pending.value
                    ? AppColors.secondary
                    : AppColors.primary,
              ),
            ),
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) {
                    if (state.latestRequest?.status ==
                        SurveyRequestStatus.pending.value) {
                      return AppDialog(
                        title: S.of(context).dialogTitleCancelSurvey,
                        body: S.of(context).dialogBodyCancelSurvey,
                        onCancelPressed: () {},
                        onConfirmPressed: () {
                          context.read<PreviewSurveyBloc>().cancelRequest();
                        },
                      );
                    } else {
                      return AppDialog(
                        title: S.of(context).dialogTitleRequestSurvey,
                        body: S.of(context).dialogBodyRequestSurvey,
                        child: AppTextField(
                          hintText: S.of(context).hintRequestSurveyMess,
                          onTextChange: (newText) {
                            context
                                .read<PreviewSurveyBloc>()
                                .onRequestMessageChange(newText);
                          },
                        ),
                        onCancelPressed: () {},
                        onConfirmPressed: () {
                          context.read<PreviewSurveyBloc>().requestSurvey();
                        },
                      );
                    }
                  },
                ).then((value) {
                  context.read<PreviewSurveyBloc>().onRequestMessageChange("");
                });
              },
              style: const ButtonStyle(
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(),
                ),
              ),
              child: state.latestRequest?.status ==
                      SurveyRequestStatus.pending.value
                  ? Text(S.of(context).labelBtnCancelRequest)
                  : Text(S.of(context).labelBtnRequest),
            ),
          ),
        );
      },
    );
  }
}
