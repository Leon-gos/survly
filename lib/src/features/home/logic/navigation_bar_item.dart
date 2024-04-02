import 'package:flutter/material.dart';
import 'package:survly/src/router/router_name.dart';

enum MyBottomNavBarItems {
  survey(
    label: 'Survey',
    route: AppRouteNames.survey,
    icon: Icons.note_alt_outlined,
    selectedIcon: Icons.note_alt_outlined,
  ),
  user(
    label: 'User',
    route: AppRouteNames.user,
    icon: Icons.supervisor_account_rounded,
    selectedIcon: Icons.supervisor_account_rounded,
  );

  const MyBottomNavBarItems({
    required this.label,
    required this.route,
    required this.icon,
    this.selectedIcon,
  });

  final String label;
  final AppRouteNames route;
  final IconData icon;
  final IconData? selectedIcon;

  static MyBottomNavBarItems fromLocation(String location) {
    if (location == MyBottomNavBarItems.survey.route.name) {
      return MyBottomNavBarItems.survey;
    }

    return MyBottomNavBarItems.survey;
  }
}
