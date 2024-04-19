import 'package:flutter/material.dart';

class AppEmptyListWidget extends StatelessWidget {
  const AppEmptyListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.sentiment_very_satisfied_outlined,
            size: 64,
            color: Colors.grey,
          ),
          Text(
            "Nothing here",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
