import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:survly/src/network/model/outlet/outlet.dart';

class SelectLocationState extends Equatable {
  final String searchText;
  final Outlet? searchedLocation;
  final LatLng? currentLocation;
  final GoogleMapController? mapController;

  const SelectLocationState({
    required this.searchText,
    this.searchedLocation,
    this.currentLocation,
    this.mapController,
  });

  factory SelectLocationState.ds({Outlet? searchedLocation}) =>
      SelectLocationState(
        searchText: "",
        searchedLocation: searchedLocation,
        mapController: null,
      );

  @override
  List<Object?> get props =>
      [searchText, searchedLocation, currentLocation, mapController];

  SelectLocationState copyWith({
    Outlet? searchedLocation,
    LatLng? currentLocation,
    String? searchText,
    GoogleMapController? mapController,
  }) {
    return SelectLocationState(
      searchedLocation: searchedLocation ?? this.searchedLocation,
      currentLocation: currentLocation ?? this.currentLocation,
      searchText: searchText ?? this.searchText,
      mapController: mapController ?? this.mapController,
    );
  }
}
