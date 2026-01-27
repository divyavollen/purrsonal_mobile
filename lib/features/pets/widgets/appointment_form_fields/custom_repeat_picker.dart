import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CustomRepeatRulePicker extends StatefulWidget {
  final DateTime startDate;

  const CustomRepeatRulePicker({
    super.key,
    required this.startDate,
  });

  @override
  State<CustomRepeatRulePicker> createState() => _CustomRepeatRulePickerState();
}

class _CustomRepeatRulePickerState extends State<CustomRepeatRulePicker> {
  int _interval = 1;
  RecurrenceType _type = RecurrenceType.daily;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Repeat every'),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: '1'),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) => _interval = int.tryParse(value) ?? 1,
              ),
            ),
            const SizedBox(width: 15),
            DropdownButton<RecurrenceType>(
              value: _type,
              items: [
                DropdownMenuItem(
                  value: RecurrenceType.daily,
                  child: Text('Day(s)'),
                ),
                DropdownMenuItem(
                  value: RecurrenceType.weekly,
                  child: Text('Week(s)'),
                ),
                DropdownMenuItem(
                  value: RecurrenceType.monthly,
                  child: Text('Month(s)'),
                ),
              ],
              onChanged: (val) => setState(() => _type = val!),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            final properties = RecurrenceProperties(
              recurrenceType: _type,
              interval: _interval,
              startDate: widget.startDate,
            );
            Navigator.pop(context, properties);
          },
          child: const Text('Done'),
        ),
      ],
    );
  }
}
