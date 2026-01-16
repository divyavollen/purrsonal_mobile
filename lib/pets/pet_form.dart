import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:workspace/models/hive/pet.dart';
import 'package:workspace/pets/components/add_pet_input_builder.dart';
import 'package:workspace/pets/components/gender_button.dart';
import 'package:workspace/pets/components/img_field.dart';
import 'package:workspace/pets/components/img_src_provider.dart';
import 'package:workspace/pets/components/pet_birthday_field.dart';
import 'package:workspace/util/image_util.dart';
import 'package:workspace/util/validator/pet_validator.dart';

class PetForm extends StatefulWidget {
  final String mode;
  final Pet? pet;
  final Function(BuildContext)? onDelete;

  const PetForm({
    super.key,
  }) : mode = 'add',
       pet = null,
       onDelete = null;

  const PetForm.edit({
    super.key,
    required this.pet,
    required this.onDelete,
  }) : mode = 'edit';

  @override
  State<PetForm> createState() => _PetFormState();
}

class _PetFormState extends State<PetForm> {
  final _formKey = GlobalKey<FormState>();
  final Box<Pet> _petBox = Hive.box<Pet>('pets');
  bool _isEditMode = false;
  late File? _displayImage;
  late Pet _currentPet;

  @override
  void initState() {
    super.initState();

    if (widget.mode == 'edit') {
      _isEditMode = true;
      _currentPet = widget.pet!.copyWith();
      _getisplayImage();
    } else {
      _currentPet = _currentPet = Pet.empty();
      _displayImage = null;
    }
  }

  void _onGenderSelectionChange(Set<String> newSelection) {
    setState(() {
      if (newSelection.isEmpty) {
        _currentPet.gender = '';
      } else {
        _currentPet.gender = newSelection.first;
      }
    });
  }

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();

      if (_isEditMode) {
        await _petBox.put(widget.pet!.key, _currentPet);
      } else {
        await _petBox.add(_currentPet);
      }

      if (!mounted) return;

      Navigator.pop(context);
    }
  }

  void _showDatePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1995),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && mounted) {
      setState(() {
        _currentPet.birthdayMillis = pickedDate.millisecondsSinceEpoch;
      });
    }
  }

  Future<void> _getisplayImage() async {
    if (_currentPet.imagePath == null) {
      return;
    }

    setState(() {
      _displayImage = ImageUtil().getImage(_currentPet);
    });
  }

  Future<void> _onPickImage(ImageSource source) async {
    final XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile == null) return;

    final String fileName = p.basename(pickedFile.path);
    final String? fullPath = ImageUtil().getImagePath(fileName);

    if (fullPath != null) {
      await File(pickedFile.path).copy(fullPath);

      setState(() {
        _currentPet.imagePath = fileName;
        _displayImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Form(
        key: _formKey,

        child: Scaffold(
          appBar: AppBar(
            title: Text(_isEditMode ? 'Edit Pet' : 'New Pet'),
            leadingWidth: 40,
            automaticallyImplyLeading: false,

            leading: IconButton(
              icon: const Icon(
                Icons.close_rounded,
              ),
              onPressed: () => Navigator.pop(context),
              alignment: AlignmentGeometry.center,
              padding: const EdgeInsets.only(left: 15.0, bottom: 2.0),
            ),

            actions: <Widget>[
              if (_isEditMode)
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.error,
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
                    image: _displayImage,

                    showPicker: (ctx) {
                      if (!mounted) return;

                      FocusScope.of(context).unfocus();

                      showModalBottomSheet(
                        context: context,
                        showDragHandle: true,
                        builder: (context) => ImageSourceProvider(
                          pickImage: _onPickImage,
                          isUploaded: _displayImage != null,
                          clearImage: () {
                            setState(() {
                              _displayImage = null;
                              _currentPet.imagePath = null;
                            });
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 15),

                  AddPetInputBuilder.buildTextField(
                    context,
                    label: 'Name',
                    initialValue: _currentPet.name,
                    onSaved: (val) => _currentPet.name = val ?? '',
                    validator: PetValidator.validateName,
                  ),
                  const SizedBox(height: 15),

                  AddPetInputBuilder.buildDropDownField(
                    context,
                    label: 'Species',
                    maxLength: 10,
                    initialValue: _currentPet.species,
                    onSaved: (val) => _currentPet.species = val ?? '',
                    validator: (v) =>
                        PetValidator.validateRequired(v, 'Species'),
                  ),
                  const SizedBox(height: 15),

                  AddPetInputBuilder.buildTextField(
                    context,
                    label: 'Breed',
                    initialValue: _currentPet.breed,
                    onSaved: (val) => _currentPet.breed = val ?? '',
                    formatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                    ],
                  ),
                  const SizedBox(height: 15),

                  PetBirthdayField(
                    currentMs: _currentPet.birthdayMillis,
                    showCalendar: _showDatePicker,
                  ),
                  const SizedBox(height: 15),

                  GenderButton(
                    initialValue: _currentPet.gender,
                    onSelectionChanged: _onGenderSelectionChange,
                    onSaved: (value) => _currentPet.gender = value ?? '',
                  ),
                  const SizedBox(height: 30),

                  ElevatedButton(
                    onPressed: _submit,
                    child: Text(_isEditMode ? 'Save' : 'Add Pet'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
