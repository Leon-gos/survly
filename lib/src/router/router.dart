import 'package:go_router/go_router.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/authentication/view/login_screen.dart';
import 'package:survly/src/features/authentication/view/signup_view.dart';
import 'package:survly/src/features/home/view/home_view.dart';
import 'package:survly/src/router/router_name.dart';

class AppRouter {
  final router = GoRouter(
    initialLocation: AppRouteNames.login.path,
    redirect: (context, state) async {
      if (state.path == AppRouteNames.login.path) {
        DomainManager domain = DomainManager();
        var loginInfo = await domain.authenticationLocal.readLoginInfo();
        if (loginInfo?.email != "") {
          return AppRouteNames.home.path;
        } else {
          return AppRouteNames.login.path;
        }
      }
      return state.path;
    },
    routes: <RouteBase>[
      GoRoute(
        name: AppRouteNames.home.name,
        path: AppRouteNames.home.path,
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        name: AppRouteNames.login.name,
        path: AppRouteNames.login.path,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        name: AppRouteNames.signUp.name,
        path: AppRouteNames.signUp.path,
        builder: (context, state) => const SignUpView(),
      ),
    ],
  );
}
