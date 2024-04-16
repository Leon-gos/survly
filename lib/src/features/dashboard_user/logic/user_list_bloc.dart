import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/dashboard_user/logic/user_list_state.dart';
import 'package:survly/src/network/model/user/user.dart';

class UserListBloc extends Cubit<UserListState> {
  UserListBloc() : super(UserListState.ds()) {
    fetchUserFirstPage();
  }

  DomainManager get domainManager => DomainManager();

  Future<void> fetchUserFirstPage() async {
    List<User> list = await domainManager.user.fetchFirstPageUser();
    emit(state.copyWith(userList: []));
    emit(state.copyWith(userList: list, isLoading: false));
  }

  Future<void> fetchUserNexPage() async {
    var lastUser = state.userList[state.userList.length - 1];
    List<User> nextPageList = await domainManager.user.fetchNextPageUser(
      lastUserId: lastUser.id,
    );
    var newList = List.from(state.userList);
    newList.addAll(nextPageList);
    emit(state.copyWith(userList: nextPageList));
  }
}
