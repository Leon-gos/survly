import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:survly/src/features/authentication/bloc/sign_up_bloc.dart';
import 'package:survly/src/router/router.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = GetIt.I<AppRouter>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SignUpBloc(),
        )
      ],
      child: MaterialApp.router(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF4B9A79),
              primary: const Color(0xFF4B9A79),
              secondary: const Color(0xFFE67B3B)),
        ),
        debugShowCheckedModeBanner: false,
        routerConfig: _appRouter.router,
      ),
    );
  }
}
