import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:survly/gen/assets.gen.dart';
import 'package:survly/src/features/my_profile/widget/joined_survey_list_widget.dart';
import 'package:survly/src/features/user_profile/logic/user_profile_bloc.dart';
import 'package:survly/src/features/user_profile/logic/user_profile_state.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/model/do_survey/do_survey.dart';
import 'package:survly/src/network/model/user/user.dart';
import 'package:survly/src/router/router_name.dart';
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
        buildWhen: (previous, current) =>
            previous.isShowProfile != current.isShowProfile ||
            previous.joinedSurveyList != current.joinedSurveyList,
        builder: (context, state) {
          return Scaffold(
            appBar: AppAppBarWidget(
              backgroundColor: AppColors.backgroundBrightness,
              leadingColor: AppColors.black,
              centerTitle: true,
              title: state.isShowProfile ? null : state.user.fullname,
              titleColor: Colors.black,
              actions: [
                PopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        onTap: () {
                          context.push(AppRouteNames.updateUserProfile.path);
                        },
                        child: Text(S.of(context).labelBtnEditProfile),
                      )
                    ];
                  },
                )
              ],
            ),
            body: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  state.isShowProfile
                      ? _buildProfile(context, state.user)
                      : const SizedBox(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              S.of(context).labelNumOfSurveyJoined(
                                  state.joinedSurveyList.length),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                context
                                    .read<UserProfileBloc>()
                                    .isShowProfileChange();
                              },
                              icon: Icon(state.isShowProfile
                                  ? Icons.arrow_drop_down
                                  : Icons.arrow_drop_up),
                            )
                          ],
                        ),
                        const Divider(height: 0)
                      ],
                    ),
                  ),
                  Expanded(child: _buildSurveyLists()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfile(BuildContext context, User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
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
                    Assets.svgs.icDong.svg(
                      width: 21,
                      height: 21,
                    ),
                    Text(S.of(context).lableBalance),
                    Text(user.balance.toString()),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSurveyLists() {
    return BlocBuilder<UserProfileBloc, UserProfileState>(
      buildWhen: (previous, current) =>
          previous.joinedSurveyList != current.joinedSurveyList,
      builder: (context, state) {
        return JoinedSurveyListWidget(
          surveyList: state.joinedSurveyList,
          doSurveyList: state.doSurveyList,
          onRefresh: () => context.read<UserProfileBloc>().fetchJoinedSurvey(),
          onItemClick: (survey, doSurvey) {
            if (doSurvey.status == DoSurveyStatus.doing.value) {
              context.push(AppRouteNames.doSurvey.path, extra: survey);
            } else {
              context.push(AppRouteNames.doSurveyReview.path, extra: [
                survey.surveyId,
                doSurvey.doSurveyId,
              ]);
            }
          },
        );
      },
    );
  }
}
