import 'package:intl/intl.dart';

class NumberHelper {
  static String formatCurrency(
    int money, {
    String locale = 'vi',
    String symbol = 'VNĐ',
  }) {
    final formater = NumberFormat.currency(
      locale: locale,
      customPattern: '#,### \u00a4',
      symbol: symbol,
    );
    return formater.format(money);
  }
}
