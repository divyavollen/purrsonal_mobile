import 'package:flutter/material.dart';
import 'package:workspace/core/constants/appoinment_types_enum.dart';

class AppointmentTypeField extends StatelessWidget {
  final int? selectedType;
  final Function(int?) onSelected;

  const AppointmentTypeField({
    super.key,
    required this.selectedType,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ListTile(
          leading: Icon(Icons.event_note),
          contentPadding: EdgeInsets.fromLTRB(5, 2, 5, 0),
          title: Text('Event type'),
        ),

        ListTile(
          contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 2),
          leading: const SizedBox(width: 24),
          title: Align(
            alignment: AlignmentGeometry.centerLeft,
            child: Wrap(
              spacing: 5.0,
              children: List<Widget>.generate(
                PetAppointmentType.values.length,
                (
                  int index,
                ) {
                  return ChoiceChip(
                    showCheckmark: true,
                    label: Text(
                      PetAppointmentType.values[index].name,
                    ),
                    labelStyle: TextStyle(
                      fontWeight: selectedType == index
                          ? FontWeight.w900
                          : FontWeight.normal,
                    ),
                    selected: selectedType == index,
                    onSelected: (bool selected) {
                      onSelected(selected ? index : -1);
                    },
                  );
                },
              ).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
