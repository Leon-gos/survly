enum AppRouteNames {
  login(path: '/login'),
  signUp(path: '/signUp'),
  survey(path: '/survey'),
  user(path: '/user'),
  createSurvey(path: '/createSurvey'),
  selectLocation(path: '/selectLocation'),
  updateSurvey(path: '/updateSurvey'),
  reviewSurvey(path: '/reviewSurvey'),
  surveyRequest(path: '/surveyRequest'),
  userProfile(path: '/userProfile'),
  userLocation(path: '/userLocation'),
  userLocationTrack(path: '/userLocationTrack');

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
