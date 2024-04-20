import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/src/features/dashboard_admin/logic/account_state.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/network/model/admin/admin.dart';
import 'package:survly/src/network/model/user/user.dart';
import 'package:survly/src/network/model/user_base/user_base.dart';
import 'package:survly/src/utils/date_helper.dart';

class AccountBloc extends Cubit<AccountState> {
  AccountBloc()
      : super(AccountState.ds(UserBaseSingleton.instance().userBase!));

  void onAdminChange(UserBase userBase) {
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
    if (state.userBaseClone is User) {
      emit(
        state.copyWith(
          userBaseClone:
              (state.userBaseClone as User).copyWith(birthDate: dateString),
        ),
      );
    } else {
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

  void updateProfile() {
    emit(state.copyWith(userBase: state.userBaseClone));
  }
}
