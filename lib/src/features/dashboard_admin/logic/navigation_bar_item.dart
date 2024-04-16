import 'package:flutter/material.dart';
import 'package:survly/src/router/router_name.dart';

enum AdminBottomNavBarItems {
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

  const AdminBottomNavBarItems({
    required this.label,
    required this.route,
    required this.icon,
    this.selectedIcon,
  });

  final String label;
  final AppRouteNames route;
  final IconData icon;
  final IconData? selectedIcon;

  static AdminBottomNavBarItems fromLocation(String location) {
    if (location == AdminBottomNavBarItems.survey.route.name) {
      return AdminBottomNavBarItems.survey;
    } else if (location == AdminBottomNavBarItems.user.route.name) {
      return AdminBottomNavBarItems.user;
    }

    return AdminBottomNavBarItems.survey;
  }
}
