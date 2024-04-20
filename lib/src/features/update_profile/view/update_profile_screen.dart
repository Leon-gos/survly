import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/features/dashboard_admin/logic/account_bloc.dart';
import 'package:survly/src/features/dashboard_admin/logic/account_state.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/model/user/user.dart';
import 'package:survly/src/theme/colors.dart';
import 'package:survly/widgets/app_app_bar.dart';
import 'package:survly/widgets/app_avatar_widget.dart';
import 'package:survly/widgets/app_text_field.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final textControllerName = TextEditingController(
    text: UserBaseSingleton.instance().userBase?.fullname,
  );

  final textControllerPhone = TextEditingController(
    text: UserBaseSingleton.instance().userBase?.phone,
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountBloc(),
      child: BlocBuilder<AccountBloc, AccountState>(
        buildWhen: (previous, current) =>
            previous.userBaseClone != current.userBaseClone,
        builder: (context, state) {
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
      ),
    );
  }

  Widget _buildAvatar(User user) {
    return Container(
      width: 128,
      height: 128,
      margin: const EdgeInsets.only(bottom: 32),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AppAvatarWidget(
            avatarUrl: user.avatar,
            size: 128,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: AppColors.primary,
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.edit,
                size: 16,
              ),
            ),
          )
        ],
      ),
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
            child: const Text("Phone number"),
          ),
          AppTextField(
            textController: textControllerPhone,
            hintText: "Phone number",
            onTextChange: (newText) {
              context.read<AccountBloc>().onPhoneChanged(newText);
            },
          ),
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 4),
            child: const Text("Birth date"),
          ),
          GestureDetector(
            onTap: () async {
              await showDatePicker(
                context: context,
                firstDate: DateTime(DateTime.now().year - 65),
                lastDate: DateTime.now().subtract(
                  const Duration(days: 365 * 18),
                ),
                builder: (context, child) {
                  return DatePickerDialog(
                    firstDate: DateTime(DateTime.now().year - 65),
                    lastDate: DateTime.now().subtract(
                      const Duration(days: 365 * 18),
                    ),
                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                    initialCalendarMode: DatePickerMode.year,
                  );
                },
              ).then((date) {
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
                user.birthDate,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
