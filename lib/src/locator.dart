import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:survly/src/router/router.dart';

Future initializeApp({String? name, FirebaseOptions? firebaseOptions}) async {
  WidgetsFlutterBinding.ensureInitialized();
  _locator();
  await Firebase.initializeApp(name: name, options: firebaseOptions);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  await dotenv.load(fileName: ".env");
}

void _locator() {
  GetIt.I.registerLazySingleton(() => AppRouter());
}
