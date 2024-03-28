import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:survly/src/router/router.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = GetIt.I<AppRouter>();

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(statusBarColor: Colors.white),
    // );
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4B9A79)),
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: _appRouter.router,
    );
  }
}
