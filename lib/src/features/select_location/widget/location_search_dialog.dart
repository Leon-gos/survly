import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/network/data/location/location_data.dart';
import 'package:survly/src/network/model/fild_place/find_text_response.dart';

class LocationSearchDialog extends StatelessWidget {
  const LocationSearchDialog({
    super.key,
    required this.findText,
    required this.onSelected,
  });

  // final GoogleMapController? mapController;
  final Future<FindTextResponse> Function(String text) findText;
  final void Function(Results result) onSelected;

  // const LocationSearchDialog({
  //   super.key,
  //   required this.mapController,
  //   required this.findText,
  // });

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    return Container(
      margin: EdgeInsets.only(top: 150),
      padding: EdgeInsets.all(5),
      alignment: Alignment.topCenter,
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: SizedBox(
          width: 350,
          child: TypeAheadField<Results>(
            suggestionsCallback: (search) async {
              var response = await findText.call(search);
              // var list = await LocationData().findText(
              //   search,
              //   const LatLng(10, 10),
              // );
              return response.results;
            },
            builder: (context, controller, focusNode) {
              return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  autofocus: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'City',
                  ));
            },
            itemBuilder: (context, result) {
              return ListTile(
                title: Text(result.formattedAddress ?? "No name"),
                subtitle: Text(
                  "(${result.geometry?.location?.lat}, ${result.geometry?.location?.lng})",
                ),
              );
            },
            onSelected: (result) {
              Logger().d(result.formattedAddress);
              onSelected.call(result);
            },
          ),
        ),
      ),
    );
  }
}
