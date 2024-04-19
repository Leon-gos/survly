import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/src/features/my_profile/logic/my_profile_state.dart';
import 'package:survly/src/local/secure_storage/admin/admin_singleton.dart';
import 'package:survly/src/network/model/user/user.dart';

class MyProfileBloc extends Cubit<MyProfileState> {
  MyProfileBloc()
      : super(MyProfileState.ds(UserBaseSingleton.instance().userBase as User));
}
