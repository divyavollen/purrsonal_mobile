import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:workspace/controller/date_text_controller.dart';
import 'package:workspace/data/pet_database.dart';
import 'package:workspace/models/pet.dart';
import 'package:workspace/util/app_logger.dart';

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

  Future<void> savePet(PetDatabase petDb) async {
    String? path = '';

    if (image != null) {
      path = await saveImageLocally(image!);
    }

    petDb.addNewPet(
      Pet(
        name: nameController.text,
        species: speciesController.text,
        breed: breedController.text,
        gender: selectedGender.first,
        birthdayMillis: birthdayController.milliseconds,
        imagePath: path,
      ),
    );
  }

  Future<String?> saveImageLocally(File image) async {
    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();

      final String fileName = p.basename(image.path);
      final String localPath = p.join(appDocDir.path, fileName);

      await image.copy(localPath);

      return fileName;
    } catch (e) {
      appLogger.e("Failed to save image", error: e);
      return null;
    }
  }

  Future<void> clearImage(Function setState) async {
    setState(() => image = null);
  }
}
