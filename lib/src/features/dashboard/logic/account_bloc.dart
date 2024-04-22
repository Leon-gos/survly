import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/dashboard/logic/account_state.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/network/data/file/file_data.dart';
import 'package:survly/src/network/model/admin/admin.dart';
import 'package:survly/src/network/model/user/user.dart';
import 'package:survly/src/network/model/user_base/user_base.dart';
import 'package:survly/src/router/coordinator.dart';
import 'package:survly/src/service/picker_service.dart';
import 'package:survly/src/utils/date_helper.dart';

class AccountBloc extends Cubit<AccountState> {
  AccountBloc()
      : super(AccountState.ds(UserBaseSingleton.instance().userBase!));

  DomainManager get domainManager => DomainManager();

  void onUserbaseChange(UserBase? userBase) {
    emit(state.copyWith(userBase: userBase));
  }

  void onNameChanged(String name) {
    if (state.userBaseClone is User) {
      emit(
        state.copyWith(
          userBaseClone: (state.userBaseClone as User).copyWith(fullname: name),
        ),
      );
    } else {
      emit(
        state.copyWith(
          userBaseClone:
              (state.userBaseClone as Admin).copyWith(fullname: name),
        ),
      );
    }
  }

  void onBirthDateChanged(DateTime? date) {
    if (date == null) {
      return;
    }
    var dateString = DateHelper.getDateOnly(date);
    if (state.isUser) {
      emit(
        state.copyWith(
          userBaseClone:
              (state.userBaseClone as User).copyWith(birthDate: dateString),
        ),
      );
    } else if (state.isAdmin) {
      emit(
        state.copyWith(
          userBaseClone:
              (state.userBaseClone as Admin).copyWith(birthDate: dateString),
        ),
      );
    }
  }

  void onPhoneChanged(String phone) {
    if (state.userBaseClone is User) {
      emit(
        state.copyWith(
          userBaseClone: (state.userBaseClone as User).copyWith(phone: phone),
        ),
      );
    } else {
      emit(
        state.copyWith(
          userBaseClone: (state.userBaseClone as Admin).copyWith(phone: phone),
        ),
      );
    }
  }

  Future<void> updateProfile() async {
    try {
      if (state.newAvtPath != "") {
        String fileKey = state.userBase.genAvatarFileKey();
        String? newAvtUrl = await FileData.instance().uploadFileImage(
          filePath: state.newAvtPath,
          fileKey: fileKey,
        );
        emit(
          state.copyWith(
            userBaseClone: state.userBaseClone.copyWith(avatar: newAvtUrl),
          ),
        );
      }
      await domainManager.user.updateUserProfile(state.userBaseClone);
      emit(state.copyWith(userBase: state.userBaseClone));
      UserBaseSingleton.instance().userBase = state.userBaseClone;
      Logger().d(state.userBase.fullname);
      Fluttertoast.showToast(msg: S.text.toastUpdateUserProfileSuccess);
      AppCoordinator.pop();
    } catch (e) {
      Logger().e("Update user profile error", error: e);
      Fluttertoast.showToast(msg: S.text.toastUpdateUserProfileFail);
    }
  }

  Future<void> pickNewAvt() async {
    final file = await PickerService.pickImageFromGallery();
    if (file != null) {
      emit(state.copyWith(newAvtPath: file.path));
    }
  }
}
