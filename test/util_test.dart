import 'package:flutter_test/flutter_test.dart';
import 'package:survly/src/utils/date_helper.dart';
import 'package:survly/src/utils/debouncer.dart';
import 'package:survly/src/utils/file_helper.dart';
import 'package:survly/src/utils/number_helper.dart';

void main() {
  test(
    "Test DateHelper",
    () {
      expect(DateHelper.getDateOnly(DateTime(2024)), "01-01-2024");
      expect(DateHelper.getDateOnly(DateTime(2024, 5)), "01-05-2024");
      expect(DateHelper.getDateOnly(DateTime(2024, 5, 7)), "07-05-2024");

      expect(
        DateHelper.getFullDateTime(DateTime(2024)),
        "2024-01-01 12:00:00",
      );
      expect(
        DateHelper.getFullDateTime(DateTime(2024, 5, 7)),
        "2024-05-07 12:00:00",
      );
      expect(
        DateHelper.getFullDateTime(DateTime(2024, 5, 7, 15)),
        "2024-05-07 03:00:00",
      );
    },
  );

  test(
    "Test NumberHelper",
    () {
      expect(NumberHelper.formatCurrency(0), "0 VNĐ");
      expect(NumberHelper.formatCurrency(1000), "1.000 VNĐ");
      expect(NumberHelper.formatCurrency(20000), "20.000 VNĐ");
      expect(NumberHelper.formatCurrency(300000), "300.000 VNĐ");
    },
  );

  test(
    "Test FileHelper",
    () {
      expect(FileHelper.getFileType(filePath: "../assets/images/dong_icon.png"),
          "png");
      expect(FileHelper.getFileType(filePath: "../assets/svgs/ic_dong.svg"),
          "svg");
    },
  );

  test(
    "Test Debouncer",
    () async {
      const int delay = 1000;
      int count = 0;
      Debouncer debouncer = Debouncer(milliseconds: delay);
      debouncer.run(
        () {
          count += 1;
        },
      );
      await Future.delayed(const Duration(milliseconds: delay));
      debouncer.run(
        () {
          count += 1;
        },
      );
      expect(count, 1);

      await Future.delayed(const Duration(milliseconds: delay));
      expect(count, 2);
    },
  );
}
