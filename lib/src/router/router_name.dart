enum AppRouteNames {
  login(path: '/login'),
  signUp(path: '/signUp'),
  survey(path: '/survey'),
  user(path: '/user'),
  createSurvey(path: '/createSurvey'),
  selectLocation(path: '/selectLocation');

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
