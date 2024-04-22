import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:survly/gen/fonts.gen.dart';
import 'package:survly/src/features/dashboard/logic/account_bloc.dart';
import 'package:survly/src/router/router.dart';
import 'package:survly/src/theme/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = GetIt.I<AppRouter>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountBloc(),
      child: MaterialApp.router(
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              primary: AppColors.primary,
              onPrimary: AppColors.onPrimary,
              secondary: AppColors.secondary,
            ),
            scaffoldBackgroundColor: AppColors.backgroundBrightness,
            fontFamily: FontFamily.quicksand,
            splashColor: Colors.black45),
        debugShowCheckedModeBanner: false,
        routerConfig: _appRouter.router,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // English
        ],
      ),
    );
  }
}
