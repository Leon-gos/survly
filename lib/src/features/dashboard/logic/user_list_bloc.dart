import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/dashboard/logic/user_list_state.dart';
import 'package:survly/src/network/model/user/user.dart';

class UserListBloc extends Cubit<UserListState> {
  UserListBloc() : super(UserListState.ds()) {
    fetchUserList();
  }

  DomainManager get domainManager => DomainManager();

  Future<void> fetchUserList() async {
    List<User> list = await domainManager.user.fetchAllUser();
    emit(state.copyWith(userList: list, isLoading: false));
  }
}
