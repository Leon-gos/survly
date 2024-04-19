import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/src/features/my_profile/logic/my_profile_bloc.dart';
import 'package:survly/src/features/my_profile/logic/my_profile_state.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/widgets/app_app_bar.dart';
import 'package:survly/widgets/app_avatar_widget.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyProfileBloc(),
      child: BlocBuilder<MyProfileBloc, MyProfileState>(
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
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.timer_outlined),
                            Text(S.of(context).labelDoing),
                            Text("${state.user.countDoing}"),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_circle_outline_outlined),
                            Text(S.of(context).labelDone),
                            Text("${state.user.countDone}"),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.attach_money_outlined),
                            Text(S.of(context).lableBalance),
                            Text(state.user.balance.toString()),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Text("\" ${state.user.intro} \""),
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
