import 'package:go_router/go_router.dart';
import 'package:survly/src/features/home/view/home_view.dart';
import 'package:survly/src/router/router_name.dart';

class AppRouter {
  final router = GoRouter(
    initialLocation: AppRouteNames.home.path,
    routes: <RouteBase>[
      GoRoute(
        name: AppRouteNames.home.name,
        path: AppRouteNames.home.path,
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        name: AppRouteNames.home.name,
        path: AppRouteNames.home.path,
        builder: (context, state) => const HomeView(),
      ),
    ],
  );
}