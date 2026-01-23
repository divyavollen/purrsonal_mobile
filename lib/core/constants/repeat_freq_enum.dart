enum Frequency { daily, weekly, monthly, yearly, custom }

extension FrequencyExt on Frequency {
  String get name {
    switch (this) {
      case Frequency.daily:
        return 'DAILY';

      case Frequency.weekly:
        return 'WEEKLY';

      case Frequency.monthly:
        return 'MONTHLY';

      case Frequency.yearly:
        return 'YEARLY';

      case Frequency.custom:
        return 'CUSTOM..';
    }
  }
}
