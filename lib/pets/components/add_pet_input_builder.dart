import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workspace/pets/components/pet_species_enum.dart';

class AddPetInputBuilder extends StatelessWidget {
  const AddPetInputBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  static Widget buildTextField(
    BuildContext context, {
    required String label,
    String? initialValue,
    String? Function(String?)? validator,
    List<TextInputFormatter>? formatters,
    void Function(String?)? onSaved,
    int maxLength = 30,
  }) {
    return TextFormField(
      initialValue: initialValue,
      onSaved: onSaved,
      decoration: InputDecoration(
        labelText: label,
        counterText: '',
      ),
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      inputFormatters: formatters,
      maxLength: maxLength,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.text,
      onTapOutside: (PointerDownEvent event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }

  static Widget buildDropDownField(
    BuildContext context, {
    required String label,
    String? initialValue,
    String? Function(String?)? validator,
    List<TextInputFormatter>? formatters,
    void Function(String?)? onSaved,
    int maxLength = 30,
  }) {
    return FormField<String>(
      initialValue: initialValue,
      onSaved: onSaved,
      validator: validator,
      builder: (FormFieldState<String> state) {
        return DropdownMenu<String>(
          initialSelection: state.value,
          label: Text(label),
          expandedInsets: EdgeInsets.zero,
          errorText: state.errorText,

          inputDecorationTheme: Theme.of(
            context,
          ).inputDecorationTheme.copyWith(),
          dropdownMenuEntries: PetSpecies.values.map((PetSpecies species) {
            return DropdownMenuEntry<String>(
              value: species.name,
              label: species.name,
            );
          }).toList(),
          onSelected: (String? value) {
            state.didChange(value);
            onSaved?.call(value);
          },
        );
      },
    );
  }
}
