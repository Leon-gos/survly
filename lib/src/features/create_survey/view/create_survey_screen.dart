import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/features/create_survey/logic/create_survey_bloc.dart';
import 'package:survly/src/features/create_survey/logic/create_survey_state.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/theme/colors.dart';
import 'package:survly/widgets/app_app_bar.dart';
import 'package:survly/widgets/app_image_picker.dart';
import 'package:survly/widgets/app_text_field.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CreateSurveyScreen extends StatelessWidget {
  const CreateSurveyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateSurveyBloc>(
      create: (context) => CreateSurveyBloc(),
      child: BlocBuilder<CreateSurveyBloc, CreateSurveyState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppAppBarWidget(
              title: S.of(context).titleCreateSurvey,
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    context.read<CreateSurveyBloc>().saveSurvey();
                  },
                  icon: const Icon(
                    Icons.save,
                    color: AppColors.white,
                  ),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  AppImagePicker(
                    onPickImage: () {
                      context.read<CreateSurveyBloc>().onPickImage();
                    },
                    imagePath: state.imageLocalPath,
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: const AppTextField(
                      hintText: "Title",
                      label: "Title",
                      textInputType: TextInputType.text,
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: const AppTextField(
                      hintText: "Description",
                      label: "Description",
                      textInputType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: AppTextField(
                            hintText: "Respondent number",
                            label: "Respondent number",
                            textInputType: TextInputType.number,
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          flex: 1,
                          child: AppTextField(
                            hintText: "Cost",
                            label: "Cost",
                            textInputType: TextInputType.number,
                          ),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        useSafeArea: true,
                        builder: (newContext) {
                          return SizedBox(
                            width: double.infinity,
                            height: 400,
                            child: SfDateRangePicker(
                              backgroundColor: AppColors.white,
                              confirmText: "OK",
                              cancelText: "Cancel",
                              showActionButtons: true,
                              onSubmit: (p0) {
                                Logger().d(p0);
                                context
                                    .read<CreateSurveyBloc>()
                                    .onDateRangeChange(p0 as PickerDateRange);
                                context.pop();
                              },
                              onCancel: () {
                                context.pop();
                              },
                              headerStyle: const DateRangePickerHeaderStyle(
                                backgroundColor: AppColors.secondary,
                                textStyle: TextStyle(color: AppColors.white),
                              ),
                              view: DateRangePickerView.month,
                              selectionMode: DateRangePickerSelectionMode.range,
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.5, color: Colors.grey),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      child: Text(
                        "From ${state.survey.dateStart} to ${state.survey.dateEnd}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add_box_outlined),
                    label: const Text("Add question"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
