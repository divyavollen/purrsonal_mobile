import 'package:age_calculator/age_calculator.dart';
import 'package:intl/intl.dart';

class DateUtil {
  String formatDate(int? ms) {
    if (ms == null || ms < 1) return '';

    var dt = DateTime.fromMillisecondsSinceEpoch(ms);
    return DateFormat('yyyy/MM/dd').format(dt);
  }

  DateTime? getDate(int? ms) {
    if (ms == null || ms < 1) return null;

    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  String getAge(int? ms) {
    if (ms == null || ms < 1) return '';

    DateTime? dt = DateUtil().getDate(ms);

    if (dt != null) {
      DateDuration duration = AgeCalculator.age(dt);
      List<String> parts = [];

      if (duration.years > 0) {
        duration.years == 1
            ? parts.add('${duration.years} year')
            : parts.add('${duration.years} years');
      }

      if (duration.years == 0 && duration.months > 0) {
        duration.months == 1
            ? parts.add('${duration.months} month')
            : parts.add('${duration.months} months');
      }

      if (duration.years == 0 && duration.months == 0 && duration.days > 0) {
        duration.days == 1
            ? parts.add('${duration.days} day')
            : parts.add('${duration.days} days');
      }

      return parts.join(' ');
    }

    return '';
  }
}
