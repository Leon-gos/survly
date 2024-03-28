import 'package:flutter/material.dart';
import 'package:survly/widgets/app_button.dart';
import 'package:survly/widgets/app_text_field.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4B9A79),
      ),
      body: Builder(
        builder: (context) {
          return SafeArea(
            child: Container(
              color: const Color(0xFF4B9A79),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildTitle(context),
                  ),
                  Expanded(
                    flex: 7,
                    child: _buildSignUpForm(),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Scaffold.of(context).appBarMaxHeight ?? 0),
      padding: const EdgeInsets.all(32),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Survly",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            "Share Your Survey and Share Happiness",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            const AppTextField(
              hintText: "Email",
            ),
            const SizedBox(
              height: 16,
            ),
            const AppTextField(
              hintText: "Username",
            ),
            const SizedBox(
              height: 16,
            ),
            const AppTextField(
              hintText: "Name",
            ),
            const SizedBox(
              height: 16,
            ),
            const AppTextField(
              hintText: "Password",
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                onPressed: () {},
                title: "Sign up",
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Have an account? ",
                  style: TextStyle(color: Colors.black),
                ),
                Material(
                  child: InkWell(
                    onTap: () {
                      print("ok");
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      child: Text(
                        "Log In",
                        style: TextStyle(
                          color: Color(0xFFE67B3B),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
