import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/features/select_location/logic/select_location_bloc.dart';
import 'package:survly/src/features/select_location/logic/select_location_state.dart';
import 'package:survly/src/features/select_location/widget/location_search_dialog.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/model/outlet/outlet.dart';
import 'package:survly/src/theme/colors.dart';
import 'package:survly/widgets/app_loading_circle.dart';

class SelectLocationScreen extends StatelessWidget {
  const SelectLocationScreen({super.key, this.searchedLocation});

  final Outlet? searchedLocation;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SelectLocationBloc(
        searchedLocation: searchedLocation,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                  _buildSearchBar(context),
                  Positioned(
                    left: 32,
                    bottom: 32,
                    child: FloatingActionButton(
                      onPressed: () {
                        context
                            .read<SelectLocationBloc>()
                            .moveCameraToMyLocation();
                      },
                      shape: const CircleBorder(),
                      backgroundColor: Colors.white70,
                      elevation: 16,
                      child: const Icon(
                        Icons.location_searching,
                        color: Colors.black54,
                      ),
                    ),
                  )
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
            target: state.searchedLocation!.hasCoordinate()
                ? LatLng(
                    state.searchedLocation!.latitude!,
                    state.searchedLocation!.longitude!,
                  )
                : state.currentLocation!,
            zoom: 16,
          ),
          onMapCreated: (controller) {
            context
                .read<SelectLocationBloc>()
                .onMapControllerChange(controller);
          },
          markers: {
            Marker(
              markerId: const MarkerId("outlet-place"),
              position: state.searchedLocation!.hasCoordinate()
                  ? LatLng(state.searchedLocation!.latitude!,
                      state.searchedLocation!.longitude!)
                  : state.currentLocation!,
              infoWindow: InfoWindow(
                title: S.of(context).titleMarker,
                snippet: S.of(context).snippetMarker,
              ),
            ),
          },
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          onTap: (argument) {
            Logger().d("(${argument.latitude}, ${argument.longitude})");
          },
          onLongPress: (argument) {
            context.read<SelectLocationBloc>().onMapLongPressed(argument);
          },
        );
      },
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 16,
      ),
      child: Row(children: [
        Expanded(
          flex: 1,
          child: LocationSearchDialog(
            findText: (text) =>
                context.read<SelectLocationBloc>().findText(text),
            onSelected: (result) =>
                context.read<SelectLocationBloc>().moveCamera(result),
          ),
        ),
        BlocBuilder<SelectLocationBloc, SelectLocationState>(
          buildWhen: (previous, current) =>
              previous.searchedLocation != current.searchedLocation,
          builder: (context, state) {
            return IconButton(
              onPressed: () {
                context.read<SelectLocationBloc>().pop();
              },
              icon: Icon(
                state.searchedLocation!.hasCoordinate()
                    ? Icons.check
                    : Icons.pending_outlined,
              ),
              color: state.searchedLocation!.hasCoordinate()
                  ? AppColors.primary
                  : AppColors.secondary,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shadowColor: MaterialStateProperty.all(Colors.black87),
                elevation: MaterialStateProperty.all(4),
                side: MaterialStateProperty.all(
                  BorderSide(
                    width: 2,
                    color: state.searchedLocation!.hasCoordinate()
                        ? AppColors.primary
                        : AppColors.secondary,
                  ),
                ),
              ),
            );
          },
        ),
      ]),
    );
  }
}
