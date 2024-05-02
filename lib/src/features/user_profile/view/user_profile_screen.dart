import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/gen/assets.gen.dart';
import 'package:survly/src/features/user_profile/logic/user_profile_bloc.dart';
import 'package:survly/src/features/user_profile/logic/user_profile_state.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/model/user/user.dart';
import 'package:survly/src/theme/colors.dart';
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
            appBar: AppAppBarWidget(
              backgroundColor: AppColors.backgroundBrightness,
              leadingColor: Colors.black,
            ),
            body: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
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
                            Text("${user.countDoing}"),
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
                            Text("${user.countDone}"),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Assets.images.dongIcon.image(
                              width: 24,
                              height: 24,
                            ),
                            Text(S.of(context).lableBalance),
                            Text(user.balance.toString()),
                          ],
                        ),
                      )
                    ],
                  ),
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
