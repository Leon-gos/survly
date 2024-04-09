class AdminCollection {
  static const String collectionName = "admin";
  static const String fieldAdminId = "id";
  static const String fieldFullname = "fullname";
  static const String fieldEmail = "email";
  static const String fieldAvatar = "avatar";
  static const String fieldGender = "gender";
  static const String fieldBirthDate = "birthDate";
  static const String fieldPhone = "phone";
  static const String fieldRole = "role";
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
  static const String fieldLatittude = "latitude";
  static const String fieldLongitude = "longitude";
}

class QuestionCollection {
  static const String collectionName = "question";
  static const String fieldQuestionId = "questionId";
  static const String fieldQuestionIndex = "questionIndex";
  static const String fieldQuestionType = "questionType";
  static const String fieldQuestion = "question";
  static const String fieldSurveyId = "surveyId";
}

class OptionCollection {
  static const String collectionName = "option";
  static const String fieldQuestionOptionId = "questionOptionId";
  static const String fieldQuestionOptionIndex = "questionOptionIndex";
  static const String fieldOption = "option";
  static const String fieldQuestionId = "questionId";
}
