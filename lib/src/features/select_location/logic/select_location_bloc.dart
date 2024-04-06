import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/features/select_location/logic/select_location_state.dart';
import 'package:survly/src/network/data/location/location_data.dart';

class SelectLocationBloc extends Cubit<SelectLocationState> {
  SelectLocationBloc() : super(SelectLocationState.ds()) {
    getCurrentLocation();
  }

  void searchLocationByText() {
    LocationData().getLocationData(state.searchText);
    emit(
      state.copyWith(
        searchedLocation: const LatLng(11.9038989, 108.3683207),
      ),
    );
  }

  void onSearchTextChange(String text) {
    emit(state.copyWith(searchText: text));
  }

  Future<void> getCurrentLocation() async {
    Logger().d("start get current location");
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      emit(
        state.copyWith(
          searchedLocation: LatLng(position.latitude, position.longitude),
        ),
      );
      Logger()
          .d("current location: (${position.latitude}, ${position.longitude})");
    } catch (e) {
      Logger().e(e);
    }
  }
}
