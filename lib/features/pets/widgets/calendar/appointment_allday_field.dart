import 'package:flutter/material.dart';
import 'package:workspace/data/models/hive/pet_appointment.dart';

class AppointmentAllDayField extends StatelessWidget {
  final PetAppointment currentEvent;
  final Function(bool) onChanged;

  const AppointmentAllDayField({
    super.key,
    required this.currentEvent,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
      leading: Icon(
        Icons.access_time,
        color: Colors.black54,
      ),
      title: Row(
        children: <Widget>[
          const Expanded(
            child: Text('All-day'),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Switch(
                value: currentEvent.isAllDay!,
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
