import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/src/features/user_profile/logic/user_profile_state.dart';
import 'package:survly/src/network/model/user/user.dart';

class UserProfileBloc extends Cubit<UserProfileState> {
  UserProfileBloc(User user) : super(UserProfileState.ds(user));
}
