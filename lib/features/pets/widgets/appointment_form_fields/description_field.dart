import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workspace/core/constants/app_dimensions.dart';
import 'package:workspace/data/models/hive/pet_appointment.dart';
import 'package:workspace/features/pets/validators/input_validator.dart';
import 'package:workspace/features/pets/widgets/pet_form_fields/add_pet_input_builder.dart';

class DynamicDescField extends StatelessWidget {
  final Color pickedColor;
  final PetAppointment currentEvent;

  const DynamicDescField({
    super.key,
    required this.pickedColor,
    required this.currentEvent,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(5),
      leading: Icon(
        Icons.subject,
        color: pickedColor,
      ),
      title: InputBuilder.buildTextField(
        context,
        initialValue: currentEvent.description,
        label: 'Description',
        onChanged: (String value) {
          currentEvent.description = value;
        },
        onSaved: (val) => currentEvent.description = val ?? '',
        keyboardType: TextInputType.multiline,
        minLines: 4,
        maxLines: 10,
        maxLength: 200,
        fontSize: headLineSmallFontSize,
        border: InputBorder.none,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        validator: (val) => InputValidator.validateInput(val),
        formatters: [
          FilteringTextInputFormatter.allow(
            RegExp(r'[a-zA-Z\s]'),
          ),
        ],
      ),
    );
  }
}
