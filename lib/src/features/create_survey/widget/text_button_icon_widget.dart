import 'package:flutter/material.dart';
import 'package:survly/src/router/coordinator.dart';

class TextIconButtonWidget extends StatelessWidget {
  final String text;
  final Widget icon;
  final Function() onPressed;

  const TextIconButtonWidget({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        onPressed.call();
        AppCoordinator.pop();
      },
      icon: icon,
      label: Text(text),
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(
          const Size(double.infinity, 0),
        ),
        alignment: Alignment.centerLeft,
        foregroundColor: MaterialStateProperty.all(Colors.black54),
      ),
    );
  }
}
