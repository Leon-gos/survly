import 'package:intl/intl.dart';

class NumberHelper {
  static String formatCurrency(int money) {
    final formater = NumberFormat.currency(
      locale: 'vi',
      customPattern: '#,### \u00a4',
      symbol: 'VNĐ',
    );
    return formater.format(money);
  }
}
