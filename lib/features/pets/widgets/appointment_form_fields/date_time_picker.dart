import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ApptDateTimePicker extends StatelessWidget {
  final DateTime date;
  final bool isAllDay;
  final VoidCallback onDateTap;
  final VoidCallback onTimeTap;

  const ApptDateTimePicker({
    super.key,
    required this.date,
    required this.isAllDay,
    required this.onDateTap,
    required this.onTimeTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
      leading: const SizedBox(width: 24),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 7,
            child: GestureDetector(
              onTap: onDateTap,
              child: Text(
                DateFormat('EEE, MMM dd yyyy').format(date),
                textAlign: TextAlign.left,
              ),
            ),
          ),

          Expanded(
            flex: 3,
            child: isAllDay
                ? const SizedBox.shrink()
                : GestureDetector(
                    onTap: onTimeTap,
                    behavior: HitTestBehavior.opaque,
                    child: Text(
                      DateFormat('hh:mm a').format(date),
                      textAlign: TextAlign.right,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
