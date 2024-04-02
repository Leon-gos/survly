import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/src/features/home/logic/home_bloc.dart';
import 'package:survly/src/features/home/logic/home_state.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/widgets/app_app_bar.dart';
import 'package:survly/widgets/app_loading_circle.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
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
    return Scaffold(
      appBar: AppAppBarWidget(
        leading: const SizedBox(),
        title: S.of(context).labelSurvey,
      ),
      body: const Center(
        child: Text("Hello world"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.note_alt_outlined),
            label: S.of(context).labelSurvey,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.image),
            label: S.of(context).labelOutlet,
          ),
        ],
      ),
    );
  }
}
