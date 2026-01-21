enum Frequency { daily, weekly, monthly, yearly, custom }

extension FrequencyExt on Frequency {
  String get name {
    switch (this) {
      case Frequency.daily:
        return 'Daily';

      case Frequency.weekly:
        return 'Weekly';

      case Frequency.monthly:
        return 'Monthly';

      case Frequency.yearly:
        return 'Yearly';

      case Frequency.custom:
        return 'Custom..';
    }
  }
}
