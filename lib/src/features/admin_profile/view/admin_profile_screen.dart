import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:survly/src/features/admin_profile/logic/admin_profile_bloc.dart';
import 'package:survly/src/features/admin_profile/logic/admin_profile_state.dart';
import 'package:survly/src/features/dashboard/logic/account_bloc.dart';
import 'package:survly/src/features/dashboard/logic/account_state.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/model/admin/admin.dart';
import 'package:survly/src/router/router_name.dart';
import 'package:survly/src/theme/colors.dart';
import 'package:survly/widgets/app_app_bar.dart';
import 'package:survly/widgets/app_avatar_widget.dart';
import 'package:survly/widgets/app_survey_card.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminProfileBloc(),
      child: BlocBuilder<AdminProfileBloc, AdminProfileState>(
        builder: (context, state) {
          // return Scaffold(
          //   body: _buildSliver(),
          // );
          return Scaffold(
            appBar: AppAppBarWidget(
              noActionBar: true,
              backgroundColor: AppColors.backgroundBrightness,
            ),
            body: SizedBox(
              width: double.infinity,
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
                  const SizedBox(height: 32),
                  const Divider(height: 0),
                  Expanded(flex: 1, child: _buildSurveyLists()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSliver() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 190.0,
          stretch: true,
          flexibleSpace: LayoutBuilder(
            builder: (context, constraints) {
              return FlexibleSpaceBar(
                title: SizedBox(),
                background: _buildProfile(),
                stretchModes: const [StretchMode.zoomBackground],
              );
            },
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => ListTile(
              tileColor: (index % 2 == 0) ? Colors.black : Colors.green[50],
              title: Center(
                child: Text('$index',
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 50,
                        color: Colors.greenAccent[400]) //TextStyle
                    ), //Text
              ), //Center
            ), //ListTile
            childCount: 51,
          ), //SliverChildBuildDelegate
        )
      ],
    );
  }

  Widget _buildProfile() {
    return BlocBuilder<AccountBloc, AccountState>(
      buildWhen: (previous, current) => previous.userBase != current.userBase,
      builder: (context, state) {
        final user = state.userBase as Admin;
        return SizedBox(
          width: double.infinity,
          child: Column(
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
              // const SizedBox(
              //   height: 32,
              // ),
              // Row(
              //   children: [
              //     Expanded(
              //       flex: 1,
              //       child: Column(
              //         mainAxisSize: MainAxisSize.min,
              //         children: [
              //           const Icon(Icons.timer_outlined),
              //           Text(S.of(context).labelDoing),
              //           Text("${user.countDoing}"),
              //         ],
              //       ),
              //     ),
              //     Expanded(
              //       flex: 1,
              //       child: Column(
              //         mainAxisSize: MainAxisSize.min,
              //         children: [
              //           const Icon(Icons.check_circle_outline_outlined),
              //           Text(S.of(context).labelDone),
              //           Text("${user.countDone}"),
              //         ],
              //       ),
              //     ),
              //     Expanded(
              //       flex: 1,
              //       child: Column(
              //         mainAxisSize: MainAxisSize.min,
              //         children: [
              //           const Icon(Icons.attach_money_outlined),
              //           Text(S.of(context).lableBalance),
              //           Text(user.balance.toString()),
              //         ],
              //       ),
              //     )
              //   ],
              // ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSurveyLists() {
    return BlocBuilder<AdminProfileBloc, AdminProfileState>(
      buildWhen: (previous, current) =>
          previous.adminSurveyList != current.adminSurveyList,
      builder: (context, state) {
        return ListView.builder(
          itemCount: state.adminSurveyList.length,
          itemBuilder: (context, index) {
            var survey = state.adminSurveyList[index];
            return SizedBox(
                width: double.infinity, child: AppSurveyCard(survey: survey));
          },
        );
      },
    );
  }
}
