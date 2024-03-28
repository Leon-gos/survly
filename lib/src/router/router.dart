import 'package:go_router/go_router.dart';
import 'package:survly/src/features/authentication/view/signup_view.dart';
import 'package:survly/src/features/home/view/home_view.dart';
import 'package:survly/src/router/router_name.dart';

class AppRouter {
  final router = GoRouter(
    initialLocation: AppRouteNames.signUp.path,
    routes: <RouteBase>[
      GoRoute(
        name: AppRouteNames.home.name,
        path: AppRouteNames.home.path,
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        name: AppRouteNames.signUp.name,
        path: AppRouteNames.signUp.path,
        builder: (context, state) => const SignUpView(),
      ),
    ],
  );
}