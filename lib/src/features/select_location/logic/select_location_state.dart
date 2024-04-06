// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectLocationState extends Equatable {
  // Placemark pickPlaceMark = const Placemark();
  // List<Prediction> predictionList = [];
  final String searchText;
  final LatLng? searchedLocation;

  const SelectLocationState({
    required this.searchText,
    required this.searchedLocation,
  });

  factory SelectLocationState.ds() => const SelectLocationState(
        searchText: "",
        searchedLocation: null,
      );

  @override
  List<Object?> get props => [searchText, searchedLocation];

  SelectLocationState copyWith({
    LatLng? searchedLocation,
    String? searchText,
  }) {
    return SelectLocationState(
      searchedLocation: searchedLocation ?? this.searchedLocation,
      searchText: searchText ?? this.searchText,
    );
  }
}
