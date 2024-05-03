import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/features/dashboard/logic/account_bloc.dart';
import 'package:survly/src/features/dashboard/logic/account_state.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/model/user/user.dart';
import 'package:survly/src/service/picker_service.dart';
import 'package:survly/src/theme/colors.dart';
import 'package:survly/src/utils/date_helper.dart';
import 'package:survly/widgets/app_app_bar.dart';
import 'package:survly/widgets/app_avatar_picker_widget.dart';
import 'package:survly/widgets/app_loading_circle.dart';
import 'package:survly/widgets/app_text_field.dart';

class UpdateUserProfileScreen extends StatefulWidget {
  const UpdateUserProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() => _UpdateUserProfileScreenState();
}

class _UpdateUserProfileScreenState extends State<UpdateUserProfileScreen> {
  final textControllerName = TextEditingController(
    text: UserBaseSingleton.instance().userBase?.fullname,
  );

  final textControllerPhone = TextEditingController(
    text: UserBaseSingleton.instance().userBase?.phone,
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      buildWhen: (previous, current) =>
          previous.userBaseClone != current.userBaseClone ||
          previous.isLoading != current.isLoading,
      builder: (context, state) {
        if (state.isLoading) {
          return Scaffold(
            appBar: AppAppBarWidget(
              noActionBar: true,
              backgroundColor: AppColors.backgroundBrightness,
            ),
            body: const AppLoadingCircle(),
          );
        }
        return Scaffold(
          appBar: AppAppBarWidget(
            leadingColor: AppColors.black,
            backgroundColor: AppColors.backgroundBrightness,
            actions: [
              IconButton(
                onPressed: () {
                  context.read<AccountBloc>().updateProfile();
                },
                icon: const Icon(Icons.save),
              ),
              const SizedBox(width: 12),
            ],
          ),
          body: Column(
            children: [
              _buildAvatar(state.userBaseClone as User),
              _buildUserInfo(context, state.userBaseClone as User),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAvatar(User user) {
    return BlocBuilder<AccountBloc, AccountState>(
      buildWhen: (previous, current) =>
          previous.newAvtPath != current.newAvtPath,
      builder: (context, state) {
        return AppAvatarPickerWidget(
          avatarUrl: user.avatar,
          avatarLocalPath: state.newAvtPath,
          onPickImage: () {
            context.read<AccountBloc>().pickNewAvt();
          },
        );
      },
    );
  }

  Widget _buildUserInfo(BuildContext context, User user) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 4),
            child: Text(S.of(context).nameHint),
          ),
          AppTextField(
            textController: textControllerName,
            hintText: S.of(context).nameHint,
            textInputAction: TextInputAction.next,
            onTextChange: (newText) {
              context.read<AccountBloc>().onNameChanged(newText);
            },
          ),
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 4),
            child: Text(S.of(context).labelPhoneNumber),
          ),
          AppTextField(
            textController: textControllerPhone,
            hintText: S.of(context).labelPhoneNumber,
            onTextChange: (newText) {
              context.read<AccountBloc>().onPhoneChanged(newText);
            },
          ),
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 4),
            child: Text(S.of(context).labelBirthdate),
          ),
          GestureDetector(
            onTap: () async {
              PickerService.pickDate(context).then((date) {
                Logger().d(date);
                context.read<AccountBloc>().onBirthDateChanged(date);
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 1, color: Colors.black54),
              ),
              child: Text(
                DateHelper.getDateOnly(user.birthDate),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
