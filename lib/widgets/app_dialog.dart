import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/theme/colors.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.title,
    required this.body,
    this.onOkPressed,
    this.onCancelPressed,
    this.onConfirmPressed,
  });

  final String title;
  final String body;
  final Function()? onOkPressed;
  final Function()? onCancelPressed;
  final Function()? onConfirmPressed;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              body,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildCancelButton(context),
                _buildOkButton(context),
                _buildConfirmButton(context),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    if (onCancelPressed == null) {
      return const SizedBox();
    }
    return TextButton(
      onPressed: () {
        onCancelPressed?.call();
        context.pop();
      },
      child: Text(S.of(context).labelBtnCancel),
    );
  }

  Widget _buildOkButton(BuildContext context) {
    if (onOkPressed == null) {
      return const SizedBox();
    }
    return TextButton(
      onPressed: () {
        onOkPressed?.call();
        context.pop();
      },
      child: Text(S.of(context).labelBtnOk),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    if (onConfirmPressed == null) {
      return const SizedBox();
    }
    return TextButton(
      onPressed: () {
        onConfirmPressed?.call();
        context.pop();
      },
      child: Text(S.of(context).labelBtnConfirm),
    );
  }
}
