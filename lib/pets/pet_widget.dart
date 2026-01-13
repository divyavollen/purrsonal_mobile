import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:workspace/controller/add_pet_controller.dart';
import 'package:workspace/data/pet_database.dart';
import 'package:workspace/models/pet.dart';
import 'package:workspace/pets/components/add_pet_input_builder.dart';
import 'package:workspace/pets/components/gender_button.dart';
import 'package:workspace/pets/components/img_field.dart';
import 'package:workspace/pets/components/img_src_provider.dart';
import 'package:workspace/pets/components/pet_birthday_picker.dart';
import 'package:workspace/util/app_logger.dart';
import 'package:workspace/util/validator/pet_validator.dart';

class PetWidget extends StatefulWidget {
  final String mode;
  final Pet? pet;
  final Function(BuildContext)? onDelete;

  const PetWidget({
    super.key,
    required this.mode,
    this.pet,
    this.onDelete,
  });

  @override
  State<PetWidget> createState() => _PetWidgetState();
}

class _PetWidgetState extends State<PetWidget> {
  final _controller = AddPetController();
  final _formKey = GlobalKey<FormState>();
  late PetDatabase _petDb;
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    _petDb = PetDatabase(Hive.box<Pet>('pets'));

    if (widget.mode == "edit" && widget.pet != null) {
      appLogger.i('Pet Widget in Edit mode');
      isEditMode = true;
      _loadImageFromFile();

      _controller.nameController.text = widget.pet!.name;
      _controller.speciesController.text = widget.pet!.species;
      _controller.breedController.text = widget.pet!.breed;

      DateTime date = DateTime.fromMillisecondsSinceEpoch(
        widget.pet!.birthdayMillis,
      );

      String formattedDate = _formatDate(date);

      _controller.birthdayController.milliseconds = widget.pet!.birthdayMillis;
      _controller.birthdayController.text = formattedDate;

      _controller.selectedGender.add(widget.pet!.gender);
    }
  }

  void onGenderSelectionChange(Set<String> newSelection) {
    setState(() {
      if (newSelection.isEmpty) {
        _controller.selectedGender = {};
      } else {
        _controller.selectedGender = {newSelection.first};
      }
    });
  }

  void _submit() {
    if (_controller.validate(_formKey, setState)) {
      _controller.savePet(_petDb);
      Navigator.pop(context);
    }
  }

  void onBirthdayPick() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1995),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _controller.birthdayController.milliseconds =
            pickedDate.millisecondsSinceEpoch;

        String formattedDate = _formatDate(pickedDate);

        _controller.birthdayController.text = formattedDate;
      });
    }
  }

  Future<void> _loadImageFromFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final String fullPath = p.join(directory.path, widget.pet!.imagePath!);

      final file = File(fullPath);

      if (await file.exists()) {
        setState(() {
          _controller.image = file;
        });
      } else {
        appLogger.i("Image missing at: $fullPath");
      }
    } catch (e) {
      appLogger.e("Error loading image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Form(
        key: _formKey,

        child: Scaffold(
          appBar: AppBar(
            title: Text(isEditMode ? 'Edit Pet' : 'New Pet'),
            leadingWidth: 40,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(
                Icons.close_rounded,
              ),
              onPressed: () => Navigator.pop(context),
              alignment: AlignmentGeometry.center,
              padding: const EdgeInsets.only(left: 15.0, bottom: 2.0),
              iconSize: 28,
            ),

            actions: <Widget>[
              if (isEditMode)
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  tooltip: 'Delete pet',
                  onPressed: () {
                    widget.onDelete?.call(context);
                  },
                ),
            ],
          ),

          body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 20.0,
              ),
              child: Column(
                children: [
                  ImageField(
                    image: _controller.image,

                    showPicker: (ctx) => showModalBottomSheet(
                      context: ctx,
                      builder: (_) => ImageSourceProvider(
                        pickImage: (src) =>
                            _controller.pickImage(src, setState),
                        isUploaded: _controller.image != null ? true : false,
                        clearImage: () => _controller.clearImage(setState),
                      ),
                      showDragHandle: true,
                    ),
                  ),
                  const SizedBox(height: 15),

                  AddPetInputBuilder.buildTextField(
                    label: 'Name',
                    controller: _controller.nameController,
                    validator: PetValidator.validateName,
                  ),
                  const SizedBox(height: 15),

                  AddPetInputBuilder.buildTextField(
                    label: 'Species',
                    controller: _controller.speciesController,
                    maxLength: 10,
                    validator: (v) =>
                        PetValidator.validateRequired(v, 'Species'),
                    formatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                    ],
                  ),
                  const SizedBox(height: 15),

                  AddPetInputBuilder.buildTextField(
                    label: 'Breed',
                    controller: _controller.breedController,
                  ),
                  const SizedBox(height: 15),

                  PetBirthdayPicker(
                    birthdayController: _controller.birthdayController,
                    onTap: onBirthdayPick,
                  ),
                  const SizedBox(height: 15),

                  GenderButton(
                    selectedGender: _controller.selectedGender,
                    onSelectionChanged: onGenderSelectionChange,
                    genderInvalid: _controller.genderInvalid,
                  ),
                  const SizedBox(height: 30),

                  ElevatedButton(
                    onPressed: _submit,
                    child: Text(isEditMode ? 'Save' : 'Add Pet'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }
}
