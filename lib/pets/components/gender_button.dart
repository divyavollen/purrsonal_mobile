import 'package:flutter/material.dart';

class GenderButton extends StatelessWidget {
  final String? initialValue;
  final void Function(Set<String>) onSelectionChanged;
  final void Function(String?)? onSaved;

  const GenderButton({
    super.key,
    this.initialValue,
    required this.onSelectionChanged,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: initialValue,
      onSaved: onSaved,
      validator: (value) =>
          (value == null || value.isEmpty) ? 'Please select a gender' : null,
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: 'Gender',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            errorText: state.errorText,
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
              segments: [
                ButtonSegment<String>(
                  value: 'M',
                  label: Icon(
                    Icons.male,
                    size: 25,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                ButtonSegment<String>(
                  value: 'F',
                  label: Icon(
                    Icons.female,
                    size: 25,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
              selected: {
                if (state.value != null && state.value!.isNotEmpty)
                  state.value!,
              },

              onSelectionChanged: (newSelection) {
                final selectedValue = newSelection.firstOrNull;
                state.didChange(selectedValue);
                onSelectionChanged(newSelection);
              },
            ),
          ),
        );
      },
    );
  }
}
