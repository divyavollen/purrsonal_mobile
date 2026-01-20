import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:workspace/core/constants/app_dimensions.dart';

class CustomScheduleViewMonthHeader extends StatelessWidget {
  final ScheduleViewMonthHeaderDetails details;
  const CustomScheduleViewMonthHeader({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return _scheduleViewHeaderBuilder(context, details);
  }

  Widget _scheduleViewHeaderBuilder(
    BuildContext context,
    ScheduleViewMonthHeaderDetails details,
  ) {
    final String monthName = DateFormat('MMMM').format(details.date);

    return Container(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 20),
      child: Text(
        '${monthName.toUpperCase()} ${details.date.year}',
        style: TextStyle(
          fontSize: subTextFontSize,
          color: Theme.of(context).textTheme.headlineSmall!.color,
        ),
      ),
    );
  }
}
