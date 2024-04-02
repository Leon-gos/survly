import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/src/features/home/logic/bottom_nav_bloc.dart';
import 'package:survly/src/features/home/logic/home_bloc.dart';
import 'package:survly/src/features/home/logic/home_state.dart';
import 'package:survly/src/features/home/logic/navigation_bar_item.dart';
import 'package:survly/src/features/home/widget/bottom_navigation_bar.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/theme/colors.dart';
import 'package:survly/widgets/app_app_bar.dart';
import 'package:survly/widgets/app_avatar_widget.dart';
import 'package:survly/widgets/app_loading_circle.dart';

class HomeScreen extends StatelessWidget {
  final Widget body;
  final MyBottomNavBarItems currentItem;

  const HomeScreen({super.key, required this.body, required this.currentItem});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeBloc(),
        ),
        BlocProvider(
          create: (context) => BottomNavBloc(currentItem),
        ),
      ],
      child: BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return state.status == HomeStatus.loading
              ? _buildLoadingScreen()
              : _buildHomeScreen(context);
        },
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return const Scaffold(
      body: AppLoadingCircle(),
    );
  }

  Widget _buildHomeScreen(BuildContext context) {
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
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: AppColors.primary,
          child: Center(
            child: Text(
              S.of(context).labelAdmin,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const AppAvatarWidget(
                avatarUrl:
                    "https://images.pexels.com/photos/18254876/pexels-photo-18254876/free-photo-of-waves-by-the-rocky-beach.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
              ),
              const SizedBox(
                width: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AdminSingleton.instance().admin?.fullname ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(AdminSingleton.instance().admin?.email ?? ""),
                ],
              ),
              const Spacer(),
              IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
            ],
          ),
        ),
        const Divider(
          height: 0,
        ),
      ],
    );
  }
}
