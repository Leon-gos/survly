import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/src/features/dashboard_user/logic/bottom_nav_bloc.dart';
import 'package:survly/src/features/dashboard_user/logic/navigation_bar_item.dart';

class UserBottomNavBar extends StatelessWidget {
  const UserBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBloc, UserBottomNavBarItems>(
      builder: (context, state) {
        return BottomNavigationBar(
          currentIndex: state.index,
          onTap: context.read<BottomNavBloc>().onDestinationSelected,
          items: UserBottomNavBarItems.values
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
