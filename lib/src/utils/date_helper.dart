import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class DateHelper {
  static const String dateOnlyFormat = 'dd-MM-yyyy';

  static String getDateOnly(DateTime dateTime) {
    DateFormat myFormat = DateFormat(dateOnlyFormat);
    return myFormat.format(dateTime);
  }

  static DateTime? parseDateOnly(String dateOnlyString) {
    try {
      DateFormat myFormat = DateFormat(dateOnlyFormat);
      DateTime datetime = myFormat.parse(dateOnlyString);
      return datetime;
    } catch (e) {
      Logger().e(e);
    }
    return null;
  }
}
