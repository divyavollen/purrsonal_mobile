import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:workspace/controller/add_pet_controller.dart';
import 'package:workspace/data/pet_database.dart';
import 'package:workspace/models/pet.dart';
import 'package:workspace/pets/components/gender_button.dart';
import 'package:workspace/pets/components/img_field.dart';
import 'package:workspace/pets/components/img_src_provider.dart';
import 'package:workspace/pets/components/pet_birthday_picker.dart';
import 'package:workspace/util/add_pet_input_builder.dart';
import 'package:workspace/util/validator/pet_validator.dart';

class AddPet extends StatefulWidget {
  const AddPet({super.key});

  @override
  State<AddPet> createState() => _AddPetState();
}

class _AddPetState extends State<AddPet> {
  final _controller = AddPetController();
  final _formKey = GlobalKey<FormState>();
  late PetDatabase _petDb;

  @override
  void initState() {
    super.initState();
    _petDb = PetDatabase(Hive.box<Pet>('pets'));
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

        String formattedDate =
            "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";

        _controller.birthdayController.text = formattedDate;
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
            title: const Text("New Pet"),
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
                    child: const Text('Add Pet'),
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
