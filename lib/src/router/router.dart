import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:survly/src/features/authentication/view/login_screen.dart';
import 'package:survly/src/features/authentication/view/signup_view.dart';
import 'package:survly/src/features/create_survey/view/create_survey_screen.dart';
import 'package:survly/src/features/dashboard/logic/navigation_bar_item.dart';
import 'package:survly/src/features/dashboard/view/dashboard_screen.dart';
import 'package:survly/src/features/dashboard/view/survey_view.dart';
import 'package:survly/src/features/dashboard/view/user_view.dart';
import 'package:survly/src/features/do_survey/view/do_suvey_screen.dart';
import 'package:survly/src/features/do_survey_tracking/view/do_survey_tracking_screen.dart';
import 'package:survly/src/features/review_survey/view/review_survey_screen.dart';
import 'package:survly/src/features/select_location/view/select_location_screen.dart';
import 'package:survly/src/features/survey_request/view/survey_requests_screen.dart';
import 'package:survly/src/features/user_profile/view/user_profile_screen.dart';
import 'package:survly/src/network/model/outlet/outlet.dart';
import 'package:survly/src/features/update_survey/view/update_survey_screen.dart';
import 'package:survly/src/network/model/survey/survey.dart';
import 'package:survly/src/network/model/user/user.dart';
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
      GoRoute(
        name: AppRouteNames.createSurvey.name,
        path: AppRouteNames.createSurvey.path,
        parentNavigatorKey: AppCoordinator.navigatorKey,
        builder: (context, state) => const CreateSurveyScreen(),
      ),
      GoRoute(
        name: AppRouteNames.selectLocation.name,
        path: AppRouteNames.selectLocation.path,
        parentNavigatorKey: AppCoordinator.navigatorKey,
        builder: (context, state) {
          Outlet? outlet = state.extra as Outlet?;
          return SelectLocationScreen(
            searchedLocation: outlet,
          );
        },
      ),
      GoRoute(
        name: AppRouteNames.updateSurvey.name,
        path: AppRouteNames.updateSurvey.path,
        parentNavigatorKey: AppCoordinator.navigatorKey,
        builder: (context, state) {
          final survey = state.extra as Survey;
          return UpdateSurveyScreen(
            survey: survey,
          );
        },
      ),
      GoRoute(
        name: AppRouteNames.reviewSurvey.name,
        path: AppRouteNames.reviewSurvey.path,
        parentNavigatorKey: AppCoordinator.navigatorKey,
        builder: (context, state) {
          final survey = state.extra as Survey;
          return ReviewSurveyScreen(
            survey: survey,
          );
        },
      ),
      GoRoute(
        name: AppRouteNames.surveyRequest.name,
        path: AppRouteNames.surveyRequest.path,
        parentNavigatorKey: AppCoordinator.navigatorKey,
        builder: (context, state) {
          final survey = state.extra as Survey;
          return SurveyRequestScreen(
            survey: survey,
          );
        },
      ),
      GoRoute(
        name: AppRouteNames.userProfile.name,
        path: AppRouteNames.userProfile.path,
        parentNavigatorKey: AppCoordinator.navigatorKey,
        builder: (context, state) {
          final user = state.extra as User;
          return UserProfileScreen(
            user: user,
          );
        },
      ),
      GoRoute(
        name: AppRouteNames.doSurvey.name,
        path: AppRouteNames.doSurvey.path,
        parentNavigatorKey: AppCoordinator.navigatorKey,
        builder: (context, state) => const DoSurveyScreen(),
      ),
      GoRoute(
        name: AppRouteNames.doSurveyTracking.name,
        path: AppRouteNames.doSurveyTracking.path,
        parentNavigatorKey: AppCoordinator.navigatorKey,
        builder: (context, state) => const DoSurveyTrackingScreen(),
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
                child: const SurveyView(),
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
