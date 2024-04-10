import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/model/fild_place/find_text_response.dart';

class LocationSearchDialog extends StatelessWidget {
  const LocationSearchDialog({
    super.key,
    required this.findText,
    required this.onSelected,
  });

  final Future<FindTextResponse> Function(String text) findText;
  final void Function(Results result) onSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        width: double.infinity,
        child: TypeAheadField<Results>(
          suggestionsCallback: (search) async {
            var response = await findText.call(search);
            return response.results;
          },
          builder: (context, controller, focusNode) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: S.of(context).labelFindPlace,
              ),
            );
          },
          itemBuilder: (context, result) {
            return ListTile(
              title: Text(result.formattedAddress ?? "_"),
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
    );
  }
}
