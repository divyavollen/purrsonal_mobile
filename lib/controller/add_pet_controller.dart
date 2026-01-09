import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workspace/controller/date_text_controller.dart';
import 'package:workspace/data/pet_database.dart';
import 'package:workspace/models/pet.dart';

class AddPetController {
  final nameController = TextEditingController();
  final speciesController = TextEditingController();
  final breedController = TextEditingController();
  final birthdayController = DateTextEditingController();

  File? image;
  Set<String> selectedGender = {};
  bool genderInvalid = false;

  Future<void> pickImage(ImageSource source, Function setState) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked != null) {
      setState(() => image = File(picked.path));
    }
  }

  bool validate(GlobalKey<FormState> formKey, Function setState) {
    bool isFormValid = formKey.currentState?.validate() ?? false;
    setState(() => genderInvalid = selectedGender.isEmpty);
    return isFormValid && !genderInvalid;
  }

  void savePet(PetDatabase petDb) {
    petDb.addNewPet(
      Pet(
        name: nameController.text,
        species: speciesController.text,
        breed: breedController.text,
        gender: selectedGender.first,
        birthdayMillis: birthdayController.milliseconds,
      ),
    );
  }
}
