class UserCollection {
  static const String collectionName = "user";
  static const String fieldUserId = "id";
  static const String fieldFullname = "fullname";
  static const String fieldEmail = "email";
  static const String fieldAvatar = "avatar";
  static const String fieldGender = "gender";
  static const String fieldBirthDate = "birthDate";
  static const String fieldPhone = "phone";
  static const String fieldRole = "role";
  static const String fieldBalance = "balance";
}

class SurveyCollection {
  static const String collectionName = "survey";
  static const String fieldSurveyId = "surveyId";
  static const String fieldTitle = "title";
  static const String fieldDescription = "description";
  static const String fieldCost = "cost";
  static const String fieldDateCreate = "dateCreate";
  static const String fieldDateUpdate = "dateUpdate";
  static const String fieldStatus = "status";
  static const String fieldOutletId = "outletId";
  static const String fieldAdminId = "adminId";
  static const String fieldThumbnail = "thumbnail";
  static const String fieldAddress = "address";
  static const String fieldLatitude = "latitude";
  static const String fieldLongitude = "longitude";
}

class QuestionCollection {
  static const String collectionName = "question";
  static const String fieldQuestionId = "questionId";
  static const String fieldQuestionIndex = "questionIndex";
  static const String fieldQuestionType = "questionType";
  static const String fieldQuestion = "question";
  static const String fieldSurveyId = "surveyId";
  static const String fieldOptionList = "optionList";
}

class OptionCollection {
  static const String collectionName = "option";
  static const String fieldQuestionOptionId = "questionOptionId";
  static const String fieldQuestionOptionIndex = "questionOptionIndex";
  static const String fieldOption = "option";
  static const String fieldQuestionId = "questionId";
}

class SurveyRequestCollection {
  static const String collectionName = "surveyRequest";
  static const String fieldRequestId = "requestId";
  static const String fieldSurveyId = "surveyId";
  static const String fieldUserId = "userId";
  static const String fieldDateCreate = "dateCreate";
  static const String fieldStatus = "status";
  static const String fieldMessage = "message";
}

class DoSurveyCollection {
  static const String collectionName = "doSurvey";
  static const String fieldStatus = "status";
  static const String fieldUserId = "userId";
  static const String fieldCurrentLat = "currentLat";
  static const String fieldCurrentLng = "currentLng";
}

class DsLocationLog {
  static const String collectionName = "dsLocationLog";
  static const String fieldDoSurveyId = "doSurveyId";
  static const String fieldLatitude = "latitude";
  static const String fieldLongitude = "longitude";
}
