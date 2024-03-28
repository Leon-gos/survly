import 'package:flutter/material.dart';
import 'package:survly/firebase_options.dart';
import 'package:survly/src/app.dart';
import 'package:survly/src/locator.dart';

void main() {
  initializeApp(
    firebaseOptions: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
