import 'package:go_router/go_router.dart';
import 'package:survly/src/features/authentication/view/login_screen.dart';
import 'package:survly/src/features/authentication/view/signup_view.dart';
import 'package:survly/src/features/home/view/home_view.dart';
import 'package:survly/src/router/coordinator.dart';
import 'package:survly/src/router/router_name.dart';

class AppRouter {
  final router = GoRouter(
    initialLocation: AppRouteNames.home.path,
    navigatorKey: AppCoordinator.navigatorKey,
    routes: <RouteBase>[
      GoRoute(
        name: AppRouteNames.home.name,
        path: AppRouteNames.home.path,
        parentNavigatorKey: AppCoordinator.navigatorKey,
        builder: (context, state) => const HomeView(),
      ),
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
    ],
  );
}
