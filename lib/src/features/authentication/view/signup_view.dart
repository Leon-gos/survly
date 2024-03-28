import 'package:flutter/material.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Text("Survly"),
              Text("Share your survey and share happiness")
            ],
          )
        ],
      ),
    );
  }

  
}