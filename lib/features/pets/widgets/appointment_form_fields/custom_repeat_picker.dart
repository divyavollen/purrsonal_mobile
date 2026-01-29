import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:workspace/core/constants/app_dimensions.dart';
import 'package:workspace/core/utils/date_util.dart';

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
  DateTime? customEndDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Custom recurrence',
            style: TextStyle(fontSize: subHeaderFontSize),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Repeat every',
              ),
              const SizedBox(width: 15),
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
          const SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 50,
                child: Text('Ends'),
              ),
              const SizedBox(width: 15),

              Expanded(
                child: TextFormField(
                  key: ValueKey(customEndDate),
                  initialValue: customEndDate == null
                      ? 'Never'
                      : DateUtil().formatDate(customEndDate),
                  decoration: InputDecoration(
                    hintText: 'Never',
                    suffixIcon: customEndDate != null
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () =>
                                setState(() => customEndDate = null),
                          )
                        : null,
                  ),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  readOnly: true,
                  onTap: _showDatePicker,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: ElevatedButton(
              onPressed: () {
                List<WeekDays>? weekDays;
                if (_type == RecurrenceType.weekly) {
                  int dayIndex = widget.startDate.weekday % 7;
                  weekDays = [WeekDays.values[dayIndex]];
                }

                DateTime? validatedEndDate = customEndDate;
                if (validatedEndDate != null &&
                    validatedEndDate.isBefore(widget.startDate)) {
                  validatedEndDate = widget.startDate.add(
                    const Duration(hours: 1),
                  );
                }

                final properties = RecurrenceProperties(
                  recurrenceType: _type,
                  interval: _interval,
                  startDate: widget.startDate,
                  dayOfMonth: widget.startDate.day,
                  month: _type == RecurrenceType.yearly
                      ? widget.startDate.month
                      : 1,
                  recurrenceRange: customEndDate == null
                      ? RecurrenceRange.noEndDate
                      : RecurrenceRange.endDate,
                  endDate: validatedEndDate,
                  weekDays: weekDays,
                );

                Navigator.pop(context, properties);
              },
              child: const Text('Done'),
            ),
          ),
        ],
      ),
    );
  }

  void _showDatePicker() async {
    DateTime initial = customEndDate != null ? customEndDate! : DateTime.now();

    if (initial.isBefore(widget.startDate)) initial = widget.startDate;

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: widget.startDate,
      lastDate: DateTime(DateTime.now().year + 100),
    );

    if (pickedDate != null && mounted) {
      setState(() {
        customEndDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          widget.startDate.hour,
          widget.startDate.minute,
          0,
          0,
          0,
        );
      });
    }
  }
}
