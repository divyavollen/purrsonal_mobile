import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workspace/core/constants/pet_species_enum.dart';

class InputBuilder {
  static Widget buildTextField(
    BuildContext context, {
    required String label,
    String? initialValue,
    String? Function(String?)? validator,
    List<TextInputFormatter>? formatters,
    void Function(String?)? onSaved,
    void Function(String)? onChanged,
    int? maxLines = 1,
    int? minLines = 1,
    int? maxLength,
    TextInputType keyboardType = TextInputType.text,
    InputBorder? border,
    double? fontSize,
    FloatingLabelBehavior floatingLabelBehavior = FloatingLabelBehavior.auto,
    FocusNode? node,
  }) {
    return TextFormField(
      initialValue: initialValue,
      onSaved: onSaved,
      onChanged: onChanged,
      minLines: minLines,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: formatters,
      textCapitalization: TextCapitalization.sentences,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: fontSize,
      ),
      decoration: InputDecoration(
        labelText: label,
        counterText: '',
        border: border,
        floatingLabelBehavior: floatingLabelBehavior,
      ),
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      focusNode: node,
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
