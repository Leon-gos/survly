import 'dart:convert';

class Survey {
  final String surveyId;
  String? title;
  String? description;
  int? cost;
  String dateCreate;
  String dateUpdate;
  String? dateStart;
  String? dateEnd;
  String status;
  String? outletId;
  final String adminId;

  Survey({
    required this.surveyId,
    required this.adminId,
    required this.dateCreate,
    required this.dateUpdate,
    required this.status,
  });
}
