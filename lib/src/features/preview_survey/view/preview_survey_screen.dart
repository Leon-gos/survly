import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:survly/src/features/preview_survey/logic/preview_survey_bloc.dart';
import 'package:survly/src/features/preview_survey/logic/preview_survey_state.dart';
import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/widgets/app_app_bar.dart';
import 'package:survly/widgets/app_image_picker.dart';

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
                      Text(
                          "You will earn VNĐ ${state.survey.cost} if approved"),
                      const SizedBox(height: 8),
                      Text("Survey in ${survey.outlet?.address}"),
                      const SizedBox(height: 8),
                      if (state.survey.outlet != null &&
                          state.survey.outlet!.hasCoordinate())
                        Container(
                          height: 200,
                          // margin: const EdgeInsets.symmetric(horizontal: 16),
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
      ),
    );
  }
}
