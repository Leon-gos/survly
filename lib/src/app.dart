import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:survly/src/router/router.dart';
import 'package:survly/src/theme/colors.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = GetIt.I<AppRouter>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),
        fontFamily: "Quicksand",
        splashColor: Colors.black45
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: _appRouter.router,
    );
  }
}
