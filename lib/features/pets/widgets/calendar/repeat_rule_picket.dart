import 'package:flutter/material.dart';
import 'package:workspace/core/constants/repeat_freq_enum.dart';

class RepeatRulePicker extends StatelessWidget {
  final int? selectedRepeat;
  final Function(int?) onSelected;

  const RepeatRulePicker({
    super.key,
    required this.selectedRepeat,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ListTile(
          leading: Icon(Icons.repeat),
          contentPadding: EdgeInsets.fromLTRB(5, 2, 5, 0),
          title: Text('Repeat'),
        ),

        ListTile(
          contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 2),
          leading: const SizedBox(width: 24),
          title: Align(
            alignment: AlignmentGeometry.centerLeft,
            child: Wrap(
              spacing: 5.0,
              children: List<Widget>.generate(
                Frequency.values.length,
                (
                  int index,
                ) {
                  return ChoiceChip(
                    showCheckmark: true,
                    label: Text(
                      Frequency.values[index].name,
                    ),
                    labelStyle: TextStyle(
                      fontWeight: selectedRepeat == index
                          ? FontWeight.w900
                          : FontWeight.normal,
                    ),
                    selected: selectedRepeat == index,
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
