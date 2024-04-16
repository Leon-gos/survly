enum AppRouteNames {
  login(path: '/login'),
  signUp(path: '/signUp'),
  dashboard(path: '/dashboard'),
  dashboardUser(path: '/dashboardUser'),
  survey(path: '/survey'),
  user(path: '/user'),
  createSurvey(path: '/createSurvey'),
  selectLocation(path: '/selectLocation'),
  updateSurvey(path: '/updateSurvey'),
  reviewSurvey(path: '/reviewSurvey'),
  surveyRequest(path: '/surveyRequest'),
  userProfile(path: '/userProfile'),
  doSurvey(path: '/doSurvey'),
  doSurveyTracking(path: '/doSurveyTracking'),
  explore(path: '/explore'),
  doingSurvey(path: '/doingSurvey');

  const AppRouteNames({
    required this.path,
    this.paramName,
  });

  final String path;
  final String? paramName;

  String get name => path;

  String get subPath {
    if (path == '/') {
      return path;
    }
    return path.replaceFirst('/', '');
  }

  String get buildPathParam => '$path:$paramName';
  String get buildSubPathParam => '$subPath:$paramName';
}
