import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/src/features/dashboard/logic/bottom_nav_bloc.dart';
import 'package:survly/src/features/dashboard/logic/navigation_bar_item.dart';

class MyBottomNavBar extends StatelessWidget {
  const MyBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBloc, MyBottomNavBarItems>(
      builder: (context, state) {
        return BottomNavigationBar(
          currentIndex: state.index,
          onTap: context.read<BottomNavBloc>().onDestinationSelected,
          items: MyBottomNavBarItems.values
              .map(
                (e) => BottomNavigationBarItem(
                  label: e.label,
                  icon: Icon(e.icon),
                  activeIcon: Icon(e.selectedIcon),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
