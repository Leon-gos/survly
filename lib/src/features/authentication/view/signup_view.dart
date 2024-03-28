import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:survly/src/features/authentication/bloc/sign_up_bloc.dart';
import 'package:survly/src/features/authentication/bloc/sign_up_state.dart';
import 'package:survly/widgets/app_app_bar.dart';
import 'package:survly/widgets/app_button.dart';
import 'package:survly/widgets/app_text_field.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4B9A79),
      appBar: const AppAppBarWidget(),
      body: Builder(
        builder: (context) {
          return SafeArea(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: _buildTitle(context),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: (MediaQuery.sizeOf(context).height / 10) * 7,
                    child: _buildSignUpForm(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
            _buildListTextField(),
            const Spacer(),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildListTextField() {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          AppTextField(
            hintText: "Email",
            onTextChange: (newText) {
              context.read<SignUpBloc>().onEmailChange(newText);
            },
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(
            height: 16,
          ),
          AppTextField(
            hintText: "Username",
            onTextChange: (newText) {
              context.read<SignUpBloc>().onUserNameChange(newText);
            },
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(
            height: 16,
          ),
          AppTextField(
            hintText: "Name",
            onTextChange: (newText) {
              context.read<SignUpBloc>().onNameChange(newText);
            },
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(
            height: 16,
          ),
          AppTextField(
            onTextChange: (newText) {
              context.read<SignUpBloc>().onPasswordChange(newText);
            },
            hintText: "Password",
          ),
        ],
      );
    });
  }

  Widget _buildBottomButtons() {
    return Column(
      children: [
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
    );
  }
}
