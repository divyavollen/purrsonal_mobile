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
      ),
      child: SizedBox(
        width: double.infinity,
        child: SegmentedButton<String>(
          showSelectedIcon: false,
          style: SegmentedButton.styleFrom(
            side: BorderSide.none,
            padding: EdgeInsets.zero,

            selectedForegroundColor: selectedGender.firstOrNull == 'M'
                ? const Color.fromRGBO(217, 234, 243, 1)
                : selectedGender.firstOrNull == 'F'
                ? const Color.fromRGBO(245, 115, 170, 1)
                : Colors.black,

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
