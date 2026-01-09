import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workspace/components/pets/img_src_sheet.dart';
import 'package:workspace/components/pets/pet_img_picker.dart';
import 'package:workspace/controller/date_text_controller.dart';
import 'package:workspace/data/pet_database.dart';
import 'package:workspace/models/pet.dart';
import 'package:workspace/util/app_logger.dart';

class AddPet extends StatefulWidget {
  const AddPet({super.key});

  @override
  State<AddPet> createState() => _AddPetState();
}

class _AddPetState extends State<AddPet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _speciesController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final DateTextEditingController _birthdayController =
      DateTextEditingController();
  Set<String> _selectedGender = {};

  final _formKey = GlobalKey<FormState>();
  bool _genderInvalid = false;

  late PetDatabase petDb;
  late Box<Pet> petBox;
  File? _image;

  @override
  void initState() {
    super.initState();
    petBox = Hive.box<Pet>('pets');
    petDb = PetDatabase.pet(petBox);
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return ImageSourceSheet(pickImage: _pickImage);
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() => _image = File(pickedImage.path));
    }
  }

  void addNewPet() {
    bool isFormValid = _formKey.currentState!.validate();

    setState(() {
      _genderInvalid = _selectedGender.isEmpty;
    });

    if (!isFormValid || _genderInvalid) {
      logger.e("Errors in form");
      return;
    }

    Pet newPet = Pet(
      name: _nameController.text,
      species: _speciesController.text,
      breed: _breedController.text,
      gender: _selectedGender.first,
      birthdayMillis: _birthdayController.milliseconds,
    );
    setState(() {
      petDb.addNewPet(newPet);
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Form(
      key: _formKey,
      child: AlertDialog(
        title: Text("Add a New Pet"),
        contentPadding: EdgeInsets.all(30.0),

        content: SizedBox(
          width: screenWidth * 0.9,
          height: screenHeight * 0.6,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),

                Center(
                  child: PetImagePicker(
                    image: _image,
                    showPicker: _showPicker,
                  ),
                ),

                const SizedBox(
                  height: 40,
                ),

                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    counterText: '',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  controller: _nameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }

                    final nameRegExp = RegExp(r"^[\p{L} '-]+$", unicode: true);
                    if (!nameRegExp.hasMatch(value)) {
                      return 'Please use only letters and common punctuation';
                    }
                    return null;
                  },

                  maxLength: 30,
                ),

                const SizedBox(
                  height: 20,
                ),

                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Species',
                    counterText: '',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  controller: _speciesController,

                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a species';
                    }
                    return null;
                  },

                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                  ],

                  maxLength: 10,
                ),

                const SizedBox(
                  height: 20,
                ),

                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Breed',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  controller: _breedController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a species';
                    }
                    return null;
                  },
                ),

                const SizedBox(
                  height: 20,
                ),

                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Birthday',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  readOnly: true,
                  controller: _birthdayController,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1995),
                      lastDate: DateTime.now(),
                    );

                    if (pickedDate != null) {
                      setState(() {
                        _birthdayController.milliseconds =
                            pickedDate.millisecondsSinceEpoch;

                        String formattedDate =
                            "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year}";

                        _birthdayController.text = formattedDate;
                      });
                    }
                  },
                ),

                const SizedBox(
                  height: 20,
                ),

                InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    errorText: _genderInvalid ? 'Please select a gender' : null,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<String>(
                      showSelectedIcon: false,
                      style: SegmentedButton.styleFrom(
                        side: BorderSide.none,
                        padding: EdgeInsets.zero,

                        selectedForegroundColor:
                            _selectedGender.firstOrNull == 'M'
                            ? const Color.fromRGBO(217, 234, 243, 1)
                            : _selectedGender.firstOrNull == 'F'
                            ? const Color.fromRGBO(245, 115, 170, 1)
                            : Colors.black,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),

                      emptySelectionAllowed: true,
                      multiSelectionEnabled: false,

                      segments: const [
                        ButtonSegment<String>(
                          value: 'M',
                          label: Icon(
                            Icons.male,
                            size: 25,
                            color: Color.fromARGB(255, 122, 180, 214),
                          ),
                        ),
                        ButtonSegment<String>(
                          value: 'F',
                          label: Icon(
                            Icons.female,
                            size: 25,
                            color: Color.fromRGBO(225, 115, 140, 1),
                          ),
                        ),
                      ],
                      selected: _selectedGender,

                      onSelectionChanged: (Set<String> newSelection) {
                        setState(() {
                          if (newSelection.isEmpty) {
                            _selectedGender = {};
                          } else {
                            _selectedGender = {newSelection.first};
                          }
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              addNewPet();
            },
            child: Text('Add'),
          ),

          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
