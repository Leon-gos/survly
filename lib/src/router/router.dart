import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:survly/src/features/authentication/view/login_screen.dart';
import 'package:survly/src/features/authentication/view/signup_view.dart';
import 'package:survly/src/features/dashboard/logic/navigation_bar_item.dart';
import 'package:survly/src/features/dashboard/view/dashboard_screen.dart';
import 'package:survly/src/features/dashboard/view/survey_view.dart';
import 'package:survly/src/features/dashboard/view/user_view.dart';
import 'package:survly/src/router/coordinator.dart';
import 'package:survly/src/router/router_name.dart';

class AppRouter {
  final router = GoRouter(
    initialLocation: AppRouteNames.survey.path,
    navigatorKey: AppCoordinator.navigatorKey,
    routes: <RouteBase>[
      GoRoute(
        name: AppRouteNames.login.name,
        path: AppRouteNames.login.path,
        parentNavigatorKey: AppCoordinator.navigatorKey,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        name: AppRouteNames.signUp.name,
        path: AppRouteNames.signUp.path,
        parentNavigatorKey: AppCoordinator.navigatorKey,
        builder: (context, state) => const SignUpScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => DashboardScreen(
          body: child,
          currentItem: MyBottomNavBarItems.survey,
        ),
        navigatorKey: AppCoordinator.shellKey,
        routes: [
          GoRoute(
            name: AppRouteNames.survey.name,
            path: AppRouteNames.survey.path,
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: SurveyView(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                },
              );
            },
          ),
          GoRoute(
            name: AppRouteNames.user.name,
            path: AppRouteNames.user.path,
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: const UserView(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                },
              );
            },
          ),
        ],
      )
    ],
  );
}
