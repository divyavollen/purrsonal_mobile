import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PetBirthdayField extends StatelessWidget {
  final void Function()? showCalendar;
  final int? currentMs;

  const PetBirthdayField({
    super.key,
    required this.showCalendar,
    this.currentMs,
  });

  @override
  Widget build(BuildContext context) {
    final birthday = currentMs;

    return TextFormField(
      key: ValueKey(currentMs),
      initialValue: _formatDate(birthday),
      decoration: InputDecoration(
        labelText: 'Birthday',
      ),

      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
      ),
      readOnly: true,
      onTap: showCalendar,
    );
  }

  String _formatDate(int? ms) {
    if (ms == null || ms < 1) return '';

    var dt = DateTime.fromMillisecondsSinceEpoch(ms);
    return DateFormat('MM/dd/yyyy, hh:mm a').format(dt);
  }
}
