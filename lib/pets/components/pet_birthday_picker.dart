// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:workspace/controller/date_text_controller.dart';

class PetBirthdayPicker extends StatelessWidget {
  final DateTextEditingController birthdayController;
  final void Function()? onTap;

  const PetBirthdayPicker({
    super.key,
    required this.birthdayController,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Birthday',
      ),
      readOnly: true,
      controller: birthdayController,
      onTap: onTap,
    );
  }
}
