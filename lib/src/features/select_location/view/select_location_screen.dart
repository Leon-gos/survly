import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/features/select_location/logic/select_location_bloc.dart';
import 'package:survly/src/features/select_location/logic/select_location_state.dart';
import 'package:survly/src/theme/colors.dart';
import 'package:survly/widgets/app_loading_circle.dart';

class SelectLocationScreen extends StatelessWidget {
  const SelectLocationScreen({super.key});

  final LatLng homeLatLng = const LatLng(10.788373, 106.6647133);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SelectLocationBloc(),
      child: Scaffold(
        body: BlocBuilder<SelectLocationBloc, SelectLocationState>(
          buildWhen: (previous, current) =>
              previous.searchedLocation != current.searchedLocation,
          builder: (context, state) {
            if (state.searchedLocation == null) {
              return const AppLoadingCircle();
            } else {
              return Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: state.searchedLocation!,
                      zoom: 16,
                    ),
                    onMapCreated: (controller) {
                      controller.moveCamera(
                        CameraUpdate.newLatLng(state.searchedLocation!),
                      );
                    },
                    markers: {
                      Marker(
                          markerId: const MarkerId("Home"),
                          position: state.searchedLocation!,
                          infoWindow: const InfoWindow(
                            title: "Home",
                            snippet: "You have to go here",
                          )),
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    onTap: (argument) {
                      Logger()
                          .d("(${argument.latitude}, ${argument.longitude})");
                    },
                  ),
                  Container(
                    // width: MediaQuery.of(context).size.width,
                    // height: 100,
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top),
                    color: AppColors.secondary,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          child: TextField(
                            onChanged: (value) {
                              context
                                  .read<SelectLocationBloc>()
                                  .onSearchTextChange(value);
                            },
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context
                                .read<SelectLocationBloc>()
                                .searchLocationByText();
                          },
                          child: const Text(
                            "Search",
                            style:
                                TextStyle(color: AppColors.black, fontSize: 22),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
