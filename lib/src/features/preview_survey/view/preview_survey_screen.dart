import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:survly/src/features/preview_survey/logic/preview_survey_bloc.dart';
import 'package:survly/src/features/preview_survey/logic/preview_survey_state.dart';
import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/src/theme/colors.dart';
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
      child: BlocBuilder<PreviewSurveyBloc, PreviewSurveyState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppAppBarWidget(
              title: "Survey preview",
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
          );
        },
      ),
    );
  }

  Widget _buildSurveyPreview() {
    return BlocBuilder<PreviewSurveyBloc, PreviewSurveyState>(
      buildWhen: (previous, current) => previous.survey != current.survey,
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
                    const Text("You need to answer 3 question"),
                    const SizedBox(height: 8),
                    Text(
                      "From ${state.survey.dateStart} to ${state.survey.dateEnd}",
                    ),
                    const SizedBox(height: 8),
                    Text("You will earn VNĐ ${state.survey.cost} if approved"),
                    const SizedBox(height: 8),
                    Text("Survey in ${survey.outlet?.address}"),
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
          previous.hasRequested != current.hasRequested,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          width: double.infinity,
          child: Theme(
            data: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: state.hasRequested
                    ? AppColors.secondary
                    : AppColors.primary,
              ),
            ),
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) {
                    if (state.hasRequested) {
                      return AppDialog(
                        title: "Cancel request survey",
                        body: "Cancel request to do this survey?",
                        onCancelPressed: () {},
                        onConfirmPressed: () {
                          context.read<PreviewSurveyBloc>().requestSurvey();
                        },
                      );
                    } else {
                      return AppDialog(
                        title: "Request survey",
                        body: "Send request to do this survey?",
                        child: const AppTextField(
                          hintText: "Your message (not required)",
                        ),
                        onCancelPressed: () {},
                        onConfirmPressed: () {
                          context.read<PreviewSurveyBloc>().requestSurvey();
                        },
                      );
                    }
                  },
                );
              },
              style: const ButtonStyle(
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(),
                ),
              ),
              child: state.hasRequested
                  ? const Text("Request pending")
                  : const Text("Request"),
            ),
          ),
        );
      },
    );
  }
}
