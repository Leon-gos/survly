import 'package:flutter/material.dart';
import 'package:survly/src/localization/localization_utils.dart';

class AppEmptyListWidget extends StatelessWidget {
  const AppEmptyListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.sentiment_very_satisfied_outlined,
            size: 64,
            color: Colors.grey,
          ),
          Text(
            S.of(context).labelEmptyList,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
