import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:survly/gen/assets.gen.dart';
import 'package:survly/src/features/authentication/logic/login_bloc.dart';
import 'package:survly/src/features/authentication/logic/login_state.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/router/router_name.dart';
import 'package:survly/src/theme/colors.dart';
import 'package:survly/widgets/app_app_bar.dart';
import 'package:survly/widgets/app_button.dart';
import 'package:survly/widgets/app_icon_button.dart';
import 'package:survly/widgets/app_text_field.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: const AppAppBarWidget(
          leading: SizedBox(),
        ),
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
                      child: _buildLoginForm(),
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

  Widget _buildLoginForm() {
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
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          AppTextField(
            hintText: S.of(context).emailHint,
            onTextChange: (newText) {
              context.read<LoginBloc>().onEmailChange(newText);
            },
            textInputAction: TextInputAction.next,
            textInputType: TextInputType.emailAddress,
            errorText: state.email.errorOf(),
          ),
          const SizedBox(
            height: 16,
          ),
          AppTextField(
            onTextChange: (newText) {
              context.read<LoginBloc>().onPasswordChange(newText);
            },
            hintText: S.of(context).passwordHint,
            obscureText: true,
            errorText: state.password.errorOf(),
          ),
        ],
      );
    });
  }

  Widget _buildBottomButtons() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: AppButton(
              onPressed: () {
                context.read<LoginBloc>().loginWithEmailPassword();
              },
              label: S.of(context).loginBtnLabel,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Text(S.of(context).or),  
          ),
          SizedBox(
            width: double.infinity,
            child: AppIconButton(
              onPressed: () {
                context.read<LoginBloc>().loginWithGoogle();
              },
              label: S.of(context).loginGoogleBtnLabel,
              icon: Assets.svgs.icGoogle.svg(width: 21, height: 21),
              backgroundColor: AppColors.white,
              labelColor: Colors.black54,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                S.of(context).notHaveAccount,
                style: const TextStyle(color: AppColors.black),
              ),
              Material(
                child: InkWell(
                  onTap: () {
                    context.push(AppRouteNames.signUp.path);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Text(
                      S.of(context).signUpBtnLabel,
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
