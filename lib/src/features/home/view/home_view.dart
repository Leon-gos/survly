import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/src/features/home/logic/home_bloc.dart';
import 'package:survly/src/features/home/logic/home_state.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/widgets/app_app_bar.dart';
import 'package:survly/widgets/app_loading_circle.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var currentIndex = 0;
  late final HomeBloc homeBloc;

  @override
  void initState() {
    super.initState();
    homeBloc = HomeBloc();
    homeBloc.fetchAdminInfo();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => homeBloc,
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return state.status == HomeStatus.loading
              ? _buildLoadingScreen()
              : _buildHomeScreen();
        },
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return const Scaffold(
      body: AppLoadingCircle(),
    );
  }

  Widget _buildHomeScreen() {
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
          setState(() {
            currentIndex = value;
          });
        },
        currentIndex: currentIndex,
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
