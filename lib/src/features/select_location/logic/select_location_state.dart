// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectLocationState extends Equatable {
  // Placemark pickPlaceMark = const Placemark();
  // List<Prediction> predictionList = [];
  final String searchText;
  final LatLng? searchedLocation;
  final LatLng? currentLocation;
  final GoogleMapController? mapController;

  const SelectLocationState({
    required this.searchText,
    this.searchedLocation,
    this.currentLocation,
    this.mapController,
  });

  factory SelectLocationState.ds() => const SelectLocationState(
        searchText: "",
        searchedLocation: null,
        mapController: null,
      );

  @override
  List<Object?> get props =>
      [searchText, searchedLocation, currentLocation, mapController];

  SelectLocationState copyWith({
    LatLng? searchedLocation,
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
