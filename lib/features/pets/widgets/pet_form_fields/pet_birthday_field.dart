import 'package:flutter/material.dart';
import 'package:workspace/core/utils/date_util.dart';

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
    return TextFormField(
      key: ValueKey(currentMs),
      initialValue: DateUtil().formatDateMs(currentMs),
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
}
