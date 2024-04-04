import 'package:intl/intl.dart';

class DateHelper {
  static String getDateOnly(DateTime dateTime) {
    DateFormat myFormat = DateFormat('dd-MM-yyyy');
    return myFormat.format(dateTime);
  }
}
