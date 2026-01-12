import 'package:flutter/material.dart';

class GenderButton extends StatelessWidget {
  final Set<String> selectedGender;
  final ValueChanged<Set<String>> onSelectionChanged;
  final bool genderInvalid;

  const GenderButton({
    super.key,
    required this.selectedGender,
    required this.onSelectionChanged,
    required this.genderInvalid,
  });

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'Gender',
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        errorText: genderInvalid ? 'Please select a gender' : null,
        filled: false,
      ),
      child: SizedBox(
        width: double.infinity,
        child: SegmentedButton<String>(
          showSelectedIcon: false,
          style: SegmentedButton.styleFrom(
            side: BorderSide.none,
            padding: EdgeInsets.zero,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),

          emptySelectionAllowed: true,
          multiSelectionEnabled: false,

          segments: const [
            ButtonSegment<String>(
              value: 'M',
              label: Icon(
                Icons.male,
                size: 25,
                color: Color.fromARGB(255, 122, 180, 214),
              ),
            ),
            ButtonSegment<String>(
              value: 'F',
              label: Icon(
                Icons.female,
                size: 25,
                color: Color.fromRGBO(225, 115, 140, 1),
              ),
            ),
          ],
          selected: selectedGender,

          onSelectionChanged: (newSelection) {
            onSelectionChanged(newSelection);
          },
        ),
      ),
    );
  }
}
