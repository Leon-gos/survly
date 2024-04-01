import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/src/features/home/logic/home_bloc.dart';
import 'package:survly/src/features/home/logic/home_state.dart';
import 'package:survly/widgets/app_app_bar.dart';
import 'package:survly/widgets/app_loading_circle.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  var currentIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().fetchAdminInfo(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBarWidget(
        leading: SizedBox(),
        title: "Survey",
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return state.status == HomeStatus.loading
              ? const AppLoadingCircle()
              : const Center(child: Text("Hello world"));
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          
        },
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.note_alt_outlined),
            label: "Survey",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: "Outlet",
          ),
        ],
      ),
    );
  }
}
