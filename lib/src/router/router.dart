import 'package:go_router/go_router.dart';
import 'package:survly/src/features/authentication/view/login_screen.dart';
import 'package:survly/src/features/authentication/view/signup_view.dart';
import 'package:survly/src/features/home/logic/navigation_bar_item.dart';
import 'package:survly/src/features/home/view/home_view.dart';
import 'package:survly/src/features/home/view/survey_view.dart';
import 'package:survly/src/features/home/view/user_view.dart';
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
        builder: (context, state, child) => HomeScreen(
          body: child,
          currentItem: MyBottomNavBarItems.survey,
        ),
        navigatorKey: AppCoordinator.shellKey,
        routes: [
          GoRoute(
            name: AppRouteNames.survey.name,
            path: AppRouteNames.survey.path,
            builder: (context, state) => const SurveyView(),
          ),
          GoRoute(
            name: AppRouteNames.user.name,
            path: AppRouteNames.user.path,
            builder: (context, state) => const UserView(),
          ),
        ],
      )
    ],
  );
}
