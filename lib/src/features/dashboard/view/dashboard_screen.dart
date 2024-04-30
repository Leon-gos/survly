import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survly/src/features/dashboard/logic/account_bloc.dart';
import 'package:survly/src/features/dashboard/logic/account_state.dart';
import 'package:survly/src/theme/colors.dart';
import 'package:survly/widgets/app_app_bar.dart';
import 'package:survly/widgets/app_loading_circle.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      buildWhen: (previous, current) => false,
      builder: (context, state) {
        context.read<AccountBloc>().initUserbase();
        return Scaffold(
          appBar: AppAppBarWidget(
            noActionBar: true,
            backgroundColor: AppColors.backgroundBrightness,
          ),
          body: const Center(
            child: AppLoadingCircle(),
          ),
        );
      },
    );
  }
}
