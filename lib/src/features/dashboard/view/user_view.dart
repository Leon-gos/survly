import 'package:flutter/material.dart';
import 'package:survly/src/features/dashboard/widget/user_card.dart';
import 'package:survly/src/network/model/user/user.dart';

class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildUserList(),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    return Expanded(
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: UserCard(
              user: User(
                id: "id",
                fullname: "Leon",
                email: "aaa@gmail.com",
                avatar:
                    "https://img.freepik.com/free-photo/abstract-backdrop-illustration-with-multi-colored-design-shapes-generated-by-ai_188544-15582.jpg",
                gender: "male",
                birthDate: "birthDate",
                phone: "phone",
                balance: 100000,
              ),
            ),
          );
        },
      ),
    );
  }
}
