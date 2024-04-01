import 'package:flutter/material.dart';

class AppLoadingCircle extends StatelessWidget {
  const AppLoadingCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
