import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:workspace/controller/add_pet_controller.dart';
import 'package:workspace/data/pet_database.dart';
import 'package:workspace/models/pet.dart';
import 'package:workspace/pets/components/gender_button.dart';
import 'package:workspace/pets/components/img_src_sheet.dart';
import 'package:workspace/pets/components/pet_birthday_picker.dart';
import 'package:workspace/pets/components/pet_img_picker.dart';
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
    _petDb = PetDatabase.pet(Hive.box<Pet>('pets'));
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Form(
      key: _formKey,
      child: AlertDialog(
        title: Text("Add a New Pet"),

        content: SizedBox(
          width: screenWidth * 0.9,
          height: screenHeight * 0.65,
          child: SingleChildScrollView(
            child: Column(
              children: [
                PetImagePicker(
                  image: _controller.image,
                  showPicker: (ctx) => showModalBottomSheet(
                    context: ctx,
                    builder: (_) => ImageSourceSheet(
                      pickImage: (src) => _controller.pickImage(src, setState),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                AddPetInputBuilder.buildTextField(
                  label: 'Name',
                  controller: _controller.nameController,
                  validator: PetValidator.validateName,
                ),

                const SizedBox(height: 20),

                AddPetInputBuilder.buildTextField(
                  label: 'Species',
                  controller: _controller.speciesController,
                  maxLength: 10,
                  validator: (v) => PetValidator.validateRequired(v, 'Species'),
                  formatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                  ],
                ),

                const SizedBox(height: 20),

                AddPetInputBuilder.buildTextField(
                  label: 'Breed',
                  controller: _controller.breedController,
                ),

                const SizedBox(height: 20),

                PetBirthdayPicker(
                  birthdayController: _controller.birthdayController,
                  onTap: onBirthdayPick,
                ),

                const SizedBox(height: 20),

                GenderButton(
                  selectedGender: _controller.selectedGender,
                  onSelectionChanged: onGenderSelectionChange,
                  genderInvalid: _controller.genderInvalid,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: _submit, child: const Text('Add')),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
