import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/features/select_location/logic/select_location_bloc.dart';
import 'package:survly/src/features/select_location/logic/select_location_state.dart';
import 'package:survly/src/features/select_location/widget/location_search_dialog.dart';
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
              previous.currentLocation != current.currentLocation,
          builder: (context, state) {
            if (state.currentLocation == null) {
              return const AppLoadingCircle();
            } else {
              return Stack(
                children: [
                  _buildMap(),
                  // _buildSearchBox(),
                  LocationSearchDialog(
                    findText: (text) =>
                        context.read<SelectLocationBloc>().findText(text),
                    onSelected: (result) =>
                        context.read<SelectLocationBloc>().moveCamera(result),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildMap() {
    return BlocBuilder<SelectLocationBloc, SelectLocationState>(
      buildWhen: (previous, current) =>
          previous.searchedLocation != current.searchedLocation,
      builder: (context, state) {
        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: state.currentLocation!,
            zoom: 16,
          ),
          onMapCreated: (controller) {
            // controller.moveCamera(
            //   CameraUpdate.newLatLng(state.searchedLocation!),
            // );
            context
                .read<SelectLocationBloc>()
                .onMapControllerChange(controller);
          },
          markers: {
            Marker(
                markerId: const MarkerId("Home"),
                position: state.searchedLocation ?? state.currentLocation!,
                infoWindow: const InfoWindow(
                  title: "Home",
                  snippet: "You have to go here",
                )),
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          onTap: (argument) {
            Logger().d("(${argument.latitude}, ${argument.longitude})");
          },
        );
      },
    );
  }

  Widget _buildSearchBox() {
    return BlocBuilder<SelectLocationBloc, SelectLocationState>(
      buildWhen: (previous, current) => false,
      builder: (context, state) {
        return Container(
          // width: MediaQuery.of(context).size.width,
          // height: 100,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
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
                  context.read<SelectLocationBloc>().searchLocationByText();
                },
                child: const Text(
                  "Search",
                  style: TextStyle(color: AppColors.black, fontSize: 22),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
