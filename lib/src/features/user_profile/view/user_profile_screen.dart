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

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({
    super.key,
    required this.user,
  });

  final User user;

  @override
  State<StatefulWidget> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserProfileBloc(widget.user),
      child: BlocBuilder<UserProfileBloc, UserProfileState>(
        buildWhen: (previous, current) =>
            previous.isShowProfile != current.isShowProfile ||
            previous.doSurveyList != current.doSurveyList,
        builder: (context, state) {
          return Scaffold(
            appBar: AppAppBarWidget(
              backgroundColor: AppColors.backgroundBrightness,
              leadingColor: AppColors.black,
              centerTitle: true,
              title: state.isShowProfile ? null : state.user.fullname,
              titleColor: Colors.black,
            ),
            body: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  state.isShowProfile
                      ? _buildProfile(context, state.user, state)
                      : const SizedBox(),
                  Expanded(child: _buildTabbar()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabbar() {
    return BlocBuilder<UserProfileBloc, UserProfileState>(
      builder: (context, state) {
        return Column(
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 16),
                  child: Text(
                    S
                        .of(context)
                        .labelNumOfSurveyJoined(state.doSurveyList.length),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    context.read<UserProfileBloc>().isShowProfileChange();
                  },
                  icon: Icon(state.isShowProfile
                      ? Icons.arrow_drop_down
                      : Icons.arrow_drop_up),
                )
              ],
            ),
            const Divider(height: 0),
            TabBar(
              controller: tabController,
              labelColor: AppColors.secondary,
              indicatorColor: AppColors.secondary,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              tabs: [
                Tab(
                  text: S.of(context).labelTabDoing,
                ),
                Tab(
                  text: S.of(context).labelTabSubmitted,
                ),
                Tab(
                  text: S.of(context).labelTabApproved,
                ),
                Tab(
                  text: S.of(context).labelTabIgnored,
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  _buildJoinedSurveyList(DoSurveyStatus.doing),
                  _buildJoinedSurveyList(DoSurveyStatus.submitted),
                  _buildJoinedSurveyList(DoSurveyStatus.approved),
                  _buildJoinedSurveyList(DoSurveyStatus.ignored),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildJoinedSurveyList(DoSurveyStatus status) {
    return BlocBuilder<UserProfileBloc, UserProfileState>(
      buildWhen: (previous, current) =>
          previous.doSurveyList != current.doSurveyList,
      builder: (context, state) {
        return JoinedSurveyListWidget(
          doSurveyList: state.getDoSurveyListByStatus(status),
          onRefresh: () => context.read<UserProfileBloc>().fetchJoinedSurvey(),
          onItemClick: (survey, doSurvey) {
            context.push(AppRouteNames.doSurveyReview.path, extra: [
              survey.surveyId,
              doSurvey.doSurveyId,
            ]);
          },
        );
      },
    );
  }

  Widget _buildProfile(
    BuildContext context,
    User user,
    UserProfileState userProfileState,
  ) {
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
                    Text("${userProfileState.countDoing}"),
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
                    Text("${userProfileState.countDone}"),
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
}
