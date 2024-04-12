import 'package:flutter/material.dart';
import 'package:survly/src/features/dashboard/widget/user_card.dart';
import 'package:survly/src/network/model/user/user.dart';

class UserListWidget extends StatefulWidget {
  final List<User> userList;
  final Future<void> Function()? onLoadMore;
  final Function()? onRefresh;
  final Function(User user)? onItemClick;

  const UserListWidget({
    super.key,
    required this.userList,
    this.onLoadMore,
    this.onRefresh,
    this.onItemClick,
  });

  @override
  State<StatefulWidget> createState() => _UserListWidgetState();
}

class _UserListWidgetState extends State<UserListWidget> {
  final scrollController = ScrollController();
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(
      () async {
        if (scrollController.offset >=
                scrollController.position.maxScrollExtent &&
            !scrollController.position.outOfRange &&
            scrollController.position.axisDirection == AxisDirection.down) {
          setState(() {
            isLoadingMore = true;
          });
          await widget.onLoadMore?.call();
          setState(() {
            isLoadingMore = false;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        widget.onRefresh?.call();
      },
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 50),
              physics: const AlwaysScrollableScrollPhysics(),
              controller: scrollController,
              itemCount: widget.userList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    widget.onItemClick?.call(widget.userList[index]);
                  },
                  child: UserCard(
                    user: widget.userList[index],
                  ),
                );
              },
            ),
          ),
          isLoadingMore
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: CircularProgressIndicator(),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
