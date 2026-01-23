import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workspace/core/constants/app_dimensions.dart';
import 'package:workspace/data/models/hive/pet_appointment.dart';
import 'package:workspace/features/pets/validators/input_validator.dart';
import 'package:workspace/features/pets/widgets/form/add_pet_input_builder.dart';

class AppointmentTitleSection extends StatelessWidget {
  final Function()? onTap;
  final PetAppointment currentEvent;

  const AppointmentTitleSection({
    super.key,
    required this.onTap,
    required this.currentEvent,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: GestureDetector(
        onTap: onTap,
        child: Icon(
          Icons.color_lens,
          color: currentEvent.background,
          size: 24,
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
      title: InputBuilder.buildTextField(
        initialValue: currentEvent.title,
        context,
        label: 'Add title',
        onChanged: (String value) {
          currentEvent.title = value;
        },
        onSaved: (val) => currentEvent.title = val ?? '',
        maxLines: 1,
        maxLength: 20,
        fontSize: headLineSmallFontSize,
        border: InputBorder.none,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        validator: (val) => InputValidator.validateRequiredInput(
          val,
          'title',
        ),
        formatters: [
          FilteringTextInputFormatter.allow(
            RegExp(r'[a-zA-Z\s]'),
          ),
        ],
      ),
    );
  }
}
