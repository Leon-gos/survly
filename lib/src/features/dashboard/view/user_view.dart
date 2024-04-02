import 'package:flutter/material.dart';
import 'package:survly/src/localization/localization_utils.dart';

class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(S.of(context).labelUser),
    );
  }
  
}