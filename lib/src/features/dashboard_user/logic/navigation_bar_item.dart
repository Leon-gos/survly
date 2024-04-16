import 'package:flutter/material.dart';
import 'package:survly/src/router/router_name.dart';

enum UserBottomNavBarItems {
  explore(
    label: 'Explore',
    route: AppRouteNames.explore,
    icon: Icons.explore_outlined,
    selectedIcon: Icons.explore_rounded,
  ),
  doing(
    label: 'Doing',
    route: AppRouteNames.doingSurvey,
    icon: Icons.pending_actions_outlined,
    selectedIcon: Icons.pending_actions_rounded,
  );

  const UserBottomNavBarItems({
    required this.label,
    required this.route,
    required this.icon,
    this.selectedIcon,
  });

  final String label;
  final AppRouteNames route;
  final IconData icon;
  final IconData? selectedIcon;

  static UserBottomNavBarItems fromLocation(String location) {
    if (location == UserBottomNavBarItems.explore.route.name) {
      return UserBottomNavBarItems.explore;
    } else if (location == UserBottomNavBarItems.doing.route.name) {
      return UserBottomNavBarItems.doing;
    }

    return UserBottomNavBarItems.explore;
  }
}
