import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class DateHelper {
  static const String dateOnlyFormat = 'dd-MM-yyyy';

  static String getDateOnly(DateTime? dateTime) {
    if (dateTime != null) {
      DateFormat myFormat = DateFormat(dateOnlyFormat);
      return myFormat.format(dateTime);
    }
    return "";
  }

  static String getDateOnlyFromDateString(String dateTime) {
    DateFormat myFormat = DateFormat(dateOnlyFormat);
    try {
      return myFormat.format(DateTime.parse(dateTime));
    } catch (e) {
      return "";
    }
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
