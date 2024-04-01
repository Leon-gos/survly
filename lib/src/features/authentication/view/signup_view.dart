import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:survly/src/features/authentication/logic/sign_up_bloc.dart';
import 'package:survly/src/features/authentication/logic/sign_up_state.dart';
import 'package:survly/src/localization/temp_localization.dart';
import 'package:survly/src/theme/colors.dart';
import 'package:survly/widgets/app_app_bar.dart';
import 'package:survly/widgets/app_button.dart';
import 'package:survly/widgets/app_text_field.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
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
              color: AppColors.white,
            ),
          ),
          Text(
            "Share Your Survey and Share Happiness",
            style: TextStyle(
              fontSize: 16,
              color: AppColors.white,
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
      print("build");
      return Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          AppTextField(
            hintText: TempLocalization.nameHint,
            onTextChange: (newText) {
              context.read<SignUpBloc>().onNameChange(newText);
            },
            textInputAction: TextInputAction.next,
            errorText: state.name.errorOf(),
          ),
          const SizedBox(
            height: 16,
          ),
          AppTextField(
            hintText: TempLocalization.emailHint,
            onTextChange: (newText) {
              context.read<SignUpBloc>().onEmailChange(newText);
            },
            textInputAction: TextInputAction.next,
            errorText: state.email.errorOf(),
          ),
          const SizedBox(
            height: 16,
          ),
          AppTextField(
            onTextChange: (newText) {
              context.read<SignUpBloc>().onPasswordChange(newText);
            },
            hintText: TempLocalization.passwordHint,
            textInputAction: TextInputAction.next,
            errorText: state.password.errorOf(),
          ),
          const SizedBox(
            height: 16,
          ),
          AppTextField(
            onTextChange: (newText) {
            },
            hintText: TempLocalization.confirmPasswordHint,
          ),
        ],
      );
    });
  }

  Widget _buildBottomButtons() {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: AppButton(
                onPressed: () {
                  context.read<SignUpBloc>().signUpByEmailPassword();
                },
                label: TempLocalization.signUpBtnLable,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  TempLocalization.alreadyHaveAccount,
                  style: TextStyle(color: AppColors.black),
                ),
                Material(
                  child: InkWell(
                    onTap: () {
                      context.pop();
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      child: Text(
                        TempLocalization.loginBtnLabel,
                        style: TextStyle(
                          color: AppColors.secondary,
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
    );
  }
}
