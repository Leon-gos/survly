import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:survly/src/features/dashboard/logic/account_bloc.dart';
import 'package:survly/src/features/dashboard/logic/bottom_nav_bloc.dart';
import 'package:survly/src/features/dashboard/logic/dashboard_bloc.dart';
import 'package:survly/src/features/dashboard/logic/dashboard_state.dart';
import 'package:survly/src/features/dashboard/logic/navigation_bar_item.dart';
import 'package:survly/src/features/dashboard/widget/bottom_navigation_bar.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/model/user_base/user_base.dart';
import 'package:survly/src/router/router_name.dart';
import 'package:survly/widgets/app_app_bar.dart';
import 'package:survly/widgets/app_avatar_widget.dart';
import 'package:survly/widgets/app_loading_circle.dart';

class DashboardScreen extends StatelessWidget {
  final Widget body;
  final MyBottomNavBarItems currentItem;

  const DashboardScreen(
      {super.key, required this.body, required this.currentItem});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DashboardBloc(),
        ),
        BlocProvider(
          create: (context) => BottomNavBloc(currentItem),
        ),
        BlocProvider(
          create: (context) => AccountBloc(AdminSingleton.instance().admin!),
        ),
      ],
      child: BlocBuilder<DashboardBloc, DashboardState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return state.status == DashboardStatus.loading
              ? _buildLoadingScreen()
              : _buildDashboardScreen(context);
        },
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return const Scaffold(
      body: AppLoadingCircle(),
    );
  }

  Widget _buildDashboardScreen(BuildContext context) {
    return BlocBuilder<BottomNavBloc, MyBottomNavBarItems>(
      builder: (context, state) {
        return Scaffold(
          appBar: const AppAppBarWidget(
            noActionBar: true,
          ),
          body: Column(
            children: [
              _buildAdminInfo(context),
              Expanded(child: body),
            ],
          ),
          bottomNavigationBar: const MyBottomNavBar(),
        );
      },
    );
  }

  Widget _buildAdminInfo(BuildContext context) {
    return BlocBuilder<AccountBloc, UserBase>(builder: (context, state) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                AppAvatarWidget(
                  avatarUrl: state.avatar,
                  size: 48,
                ),
                const SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.fullname,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    Text(state.email),
                  ],
                ),
                const Spacer(),
                PopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        onTap: () {
                          context.push(AppRouteNames.createSurvey.path);
                        },
                        child: Text(S.of(context).titleCreateSurvey),
                      ),
                      PopupMenuItem(
                        onTap: () {
                          context.push(AppRouteNames.userLocation.path);
                        },
                        child: const Text("Demo update location"),
                      ),
                      PopupMenuItem(
                        onTap: () {
                          context.push(AppRouteNames.userLocationTrack.path);
                        },
                        child: const Text("Demo location track"),
                      ),
                    ];
                  },
                ),
                // IconButton(
                //   onPressed: () {
                //     context.push(AppRouteNames.createSurvey.path);
                //   },
                //   icon: const Icon(Icons.more_vert),
                // )
              ],
            ),
          ),
        ],
      );
    });
  }
}
