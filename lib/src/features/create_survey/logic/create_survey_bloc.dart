import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/domain_manager.dart';
import 'package:survly/src/features/create_survey/logic/create_survey_state.dart';
import 'package:survly/src/utils/date_helper.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CreateSurveyBloc extends Cubit<CreateSurveyState> {
  CreateSurveyBloc() : super(CreateSurveyState.ds());

  DomainManager domainManager = DomainManager();

  Future<void> onPickImage() async {
    var imagePath = await ImagePicker().pickImage(source: ImageSource.gallery);
    Logger().d(imagePath?.path);
    emit(state.copyWith(imageLocalPath: imagePath?.path));
  }

  void onDateRangeChange(PickerDateRange dateRange) {
    emit(
      state.copyWith(
        survey: state.survey.copyWith(
          dateStart: DateHelper.getDateOnly(dateRange.startDate!),
          dateEnd: DateHelper.getDateOnly(dateRange.endDate!),
        ),
      ),
    );
  }

  void onTitleChange(String newText) {
    emit(
      state.copyWith(survey: state.survey.copyWith(title: newText)),
    );
  }

  void onDescriptionChange(String newText) {
    emit(
      state.copyWith(survey: state.survey.copyWith(description: newText)),
    );
  }

  void onRespondentNumberChange(String newText) {
    emit(
      state.copyWith(
        survey: state.survey.copyWith(respondentMax: int.parse(newText)),
      ),
    );
  }

  void onCostChange(String newText) {
    emit(
      state.copyWith(survey: state.survey.copyWith(cost: int.parse(newText))),
    );
  }

  void saveSurvey() {
    domainManager.survey.createSurvey(state.survey);
  }
}
