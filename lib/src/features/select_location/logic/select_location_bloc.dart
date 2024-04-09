import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/features/select_location/logic/select_location_state.dart';
import 'package:survly/src/network/data/location/location_data.dart';
import 'package:survly/src/network/model/fild_place/find_text_response.dart';
import 'package:survly/src/network/model/outlet/outlet.dart';
import 'package:survly/src/router/coordinator.dart';
import 'package:survly/src/service/permission_service.dart';
import 'package:geocoding/geocoding.dart';

class SelectLocationBloc extends Cubit<SelectLocationState> {
  SelectLocationBloc() : super(SelectLocationState.ds()) {
    getCurrentLocation();
  }

  void moveCamera(Results result) {
    try {
      Outlet outlet = Outlet(
        latitude: result.geometry!.location!.lat!,
        longitude: result.geometry!.location!.lng!,
        address: result.formattedAddress,
      );
      emit(
        state.copyWith(
          searchedLocation: outlet,
        ),
      );
      state.mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(state.searchedLocation!.latitude,
              state.searchedLocation!.longitude),
          14,
        ),
      );
    } catch (e) {
      Logger().e(e);
    }
  }

  void moveCameraToMyLocation() {
    try {
      state.mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(state.currentLocation!, 16),
      );
    } catch (e) {
      Logger().e(e);
    }
  }

  Future<void> onMapLongPressed(LatLng latLng) async {
    var placemarks =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    var nearestCandidate = placemarks[0];
    String address =
        "${nearestCandidate.street}, ${nearestCandidate.subAdministrativeArea}, ${nearestCandidate.administrativeArea}, ${nearestCandidate.country}";
    emit(
      state.copyWith(
        searchedLocation: Outlet(
          latitude: latLng.latitude,
          longitude: latLng.longitude,
          address: address,
        ),
      ),
    );
  }

  Future<FindTextResponse> findText(String text) async {
    return await LocationData().findText(text, state.currentLocation!);
  }

  void onSearchTextChange(String text) {
    emit(state.copyWith(searchText: text));
  }

  Future<void> getCurrentLocation() async {
    if (!(await PermissionService.requestLocationPermission())) {
      Logger().e("No permission");
      AppCoordinator.pop();
      return;
    }

    Logger().d("start get current location");
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      emit(
        state.copyWith(
          currentLocation: LatLng(position.latitude, position.longitude),
        ),
      );
      Logger()
          .d("current location: (${position.latitude}, ${position.longitude})");
    } catch (e) {
      Logger().e(e);
    }
  }

  void onMapControllerChange(GoogleMapController mapController) {
    emit(state.copyWith(mapController: mapController));
  }

  void pop() {
    AppCoordinator.pop(state.searchedLocation);
  }
}
