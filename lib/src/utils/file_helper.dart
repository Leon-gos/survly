import 'package:path/path.dart' as p;

class FileHelper {
  static String getFileType({required String filePath}) {
    return p.extension(filePath).replaceFirst(".", "");
  }
}
