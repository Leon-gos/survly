import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:survly/src/theme/colors.dart';

class AppAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool noActionBar;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? leadingColor;

  const AppAppBarWidget({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.noActionBar = false,
    this.centerTitle = false,
    this.backgroundColor,
    this.leadingColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? AppColors.primary,
      title: title != null
          ? Text(
              title!,
              style: const TextStyle(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            )
          : const SizedBox(),
      leading: leading ??
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: leadingColor ?? Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () {
              context.pop();
            },
          ),
      leadingWidth: leading is SizedBox ? 0 : null,
      centerTitle: centerTitle,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(noActionBar ? 0 : kToolbarHeight);
}
