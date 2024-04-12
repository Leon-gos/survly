import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/src/features/user_profile/logic/user_profile_bloc.dart';
import 'package:survly/src/features/user_profile/logic/user_profile_state.dart';
import 'package:survly/src/network/model/user/user.dart';
import 'package:survly/widgets/app_app_bar.dart';
import 'package:survly/widgets/app_avatar_widget.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserProfileBloc(user),
      child: BlocBuilder<UserProfileBloc, UserProfileState>(
        builder: (context, state) {
          return Scaffold(
            appBar: const AppAppBarWidget(
              noActionBar: true,
            ),
            body: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  AppAvatarWidget(
                    avatarUrl: state.user.avatar,
                    size: 128,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    state.user.fullname,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(state.user.email),
                  const SizedBox(
                    height: 32,
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.timer_outlined),
                            Text("Doing"),
                            Text("${user.countDoing}"),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle_outline_outlined),
                            Text("Done"),
                            Text("${user.countDone}"),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.attach_money_outlined),
                            Text("Balance"),
                            Text(user.balance.toString()),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Text("\" ${user.intro} \""),
                  const Divider(
                    height: 64,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
