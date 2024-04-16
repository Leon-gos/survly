import 'package:flutter/material.dart';
import 'package:survly/src/router/router_name.dart';

enum UserBottomNavBarItems {
  survey(
    label: 'Survey',
    route: AppRouteNames.survey,
    icon: Icons.note_alt_outlined,
    selectedIcon: Icons.note_alt_outlined,
  ),
  user(
    label: 'User',
    route: AppRouteNames.user,
    icon: Icons.pending_actions_outlined,
    selectedIcon: Icons.supervisor_account_rounded,
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
    if (location == UserBottomNavBarItems.survey.route.name) {
      return UserBottomNavBarItems.survey;
    } else if (location == UserBottomNavBarItems.user.route.name) {
      return UserBottomNavBarItems.user;
    }

    return UserBottomNavBarItems.survey;
  }
}
