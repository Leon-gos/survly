import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:survly/src/features/authentication/logic/sign_up_bloc.dart';
import 'package:survly/src/features/authentication/logic/sign_up_state.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/theme/colors.dart';
import 'package:survly/widgets/app_app_bar.dart';
import 'package:survly/widgets/app_button.dart';
import 'package:survly/widgets/app_text_field.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpBloc(),
      child: Scaffold(
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
                    child: SingleChildScrollView(
                      child: SizedBox(
                        height: (MediaQuery.sizeOf(context).height / 10) * 7,
                        child: _buildSignUpForm(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            S.of(context).appName,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          Text(
            S.of(context).appSlogan,
            style: const TextStyle(
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
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 16,
          ),
          AppTextField(
            hintText: S.of(context).nameHint,
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
            hintText: S.of(context).emailHint,
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
            hintText: S.of(context).passwordHint,
            textInputAction: TextInputAction.next,
            errorText: state.password.errorOf(),
          ),
          const SizedBox(
            height: 16,
          ),
          AppTextField(
            onTextChange: (newText) {},
            hintText: S.of(context).confirmPasswordHint,
          ),
        ],
      );
    });
  }

  Widget _buildBottomButtons() {
    return BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: AppButton(
              onPressed: () {
                context.read<SignUpBloc>().signUpByEmailPassword();
              },
              label: S.of(context).signUpBtnLabel,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                S.of(context).alreadyHaveAccount,
                style: const TextStyle(color: AppColors.black),
              ),
              Material(
                child: InkWell(
                  onTap: () {
                    context.pop();
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Text(
                      S.of(context).loginBtnLabel,
                      style: const TextStyle(
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
    });
  }
}
