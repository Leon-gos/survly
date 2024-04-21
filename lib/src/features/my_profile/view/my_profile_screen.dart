import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/features/dashboard/logic/account_bloc.dart';
import 'package:survly/src/features/dashboard/logic/account_state.dart';
import 'package:survly/src/features/my_profile/logic/my_profile_bloc.dart';
import 'package:survly/src/features/my_profile/logic/my_profile_state.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/model/user/user.dart';
import 'package:survly/src/router/router_name.dart';
import 'package:survly/src/theme/colors.dart';
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
            appBar: AppAppBarWidget(
              noActionBar: true,
              backgroundColor: AppColors.backgroundBrightness,
            ),
            body: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              context.pop();
                            },
                            icon: const Icon(Icons.arrow_back_ios_new),
                          ),
                          const Spacer(),
                          PopupMenuButton(
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  onTap: () {
                                    context
                                        .push(AppRouteNames.updateProfile.path);
                                  },
                                  child:
                                      Text(S.of(context).labelBtnEditProfile),
                                )
                              ];
                            },
                          ),
                        ],
                      ),
                      _buildProfile(),
                    ],
                  ),
                  _buildSurveyLists(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfile() {
    return BlocBuilder<AccountBloc, AccountState>(
      buildWhen: (previous, current) => previous.userBase != current.userBase,
      builder: (context, state) {
        final user = state.userBase as User;
        Logger().d(user.fullname);
        return Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            AppAvatarWidget(
              avatarUrl: user.avatar,
              size: 128,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              user.fullname,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(user.email),
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
                      const Icon(Icons.attach_money_outlined),
                      Text(S.of(context).lableBalance),
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
        );
      },
    );
  }

  Widget _buildSurveyLists() {
    return const SizedBox();
  }
}
