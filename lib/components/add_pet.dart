import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
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
  final TextEditingController _birthdayController = TextEditingController();

  bool _nameInvalid = false;
  bool _speciesInvalid = false;
  bool _genderInvalid = false;

  int selectedDateMs = 0;
  Set<String> _selectedGender = {
    'M',
  }; //TODO check if default value is necessary

  late PetDatabase petDb;
  late Box<Pet> petBox;
  File? _image;

  @override
  void initState() {
    super.initState();
    petBox = Hive.box<Pet>('pets');
    petDb = PetDatabase.pet(petBox);
  }

  bool isInputValid(Pet newPet) {
    _nameInvalid = false;
    _speciesInvalid = false;
    _genderInvalid = false;

    if (newPet.name.isEmpty) {
      _nameInvalid = true;
    }

    if (newPet.name.isEmpty) {
      _speciesInvalid = true;
    }

    if (newPet.name.isEmpty) {
      _genderInvalid = true;
    }

    if (_nameInvalid || _speciesInvalid || _genderInvalid) {
      setState(() {});
      return false;
    }

    return true;
  }

  Future<void> _pickImageFromCamera() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    setState(() {
      if (pickedImage != null) {
        setState(() {
          _image = File(pickedImage.path);
        });
      } else {
        logger.d("No image selected.");
      }
    });
  }

  Future<void> _pickImageFromGallery() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      if (pickedImage != null) {
        setState(() {
          _image = File(pickedImage.path);
        });
      } else {
        logger.d("No image selected.");
      }
    });
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text(
                  'Photo Library',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                iconColor: Colors.grey[600],
                contentPadding: EdgeInsets.only(left: 25.0, top: 10.0),
                onTap: () {
                  _pickImageFromGallery();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text(
                  'Camera',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                iconColor: Colors.grey[600],
                contentPadding: EdgeInsets.only(left: 25.0, bottom: 10.0),
                onTap: () {
                  _pickImageFromCamera();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void addNewPet() {
    Pet newPet = Pet(
      name: _nameController.text,
      species: _speciesController.text,
      breed: _breedController.text,
      gender: _selectedGender.first,
      birthdayMillis: selectedDateMs,
    );

    bool isValid = isInputValid(newPet);

    if (isValid) {
      setState(() {
        petDb.addNewPet(newPet);
      });
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    //TODO Change to form for input validation
    return AlertDialog(
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

              TextField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorText: _nameInvalid ? "Please enter a name" : null,
                ),
                controller: _nameController,
              ),

              const SizedBox(
                height: 20,
              ),

              TextField(
                decoration: InputDecoration(
                  labelText: 'Species',
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorText: _speciesInvalid ? "Please enter a species" : null,
                ),
                controller: _speciesController,
              ),

              const SizedBox(
                height: 20,
              ),

              TextField(
                decoration: InputDecoration(
                  labelText: 'Breed',
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                controller: _breedController,
              ),

              const SizedBox(
                height: 20,
              ),

              TextField(
                decoration: InputDecoration(
                  labelText: 'Birthday',
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
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
                    firstDate: DateTime(1950),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      selectedDateMs = pickedDate.millisecondsSinceEpoch;

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
                  child: SegmentedButton(
                    showSelectedIcon: false,
                    style: SegmentedButton.styleFrom(
                      side: BorderSide.none,
                      padding: EdgeInsets.zero,

                      selectedForegroundColor: _selectedGender.first == 'M'
                          ? const Color.fromRGBO(217, 234, 243, 1)
                          : const Color.fromRGBO(245, 115, 170, 1),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
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
                        _selectedGender = newSelection;
                      });
                    },
                    multiSelectionEnabled: false,
                  ),
                ),
              ),

              const SizedBox(
                height: 40,
              ),

              Center(
                child: GestureDetector(
                  onTap: () {
                    _showPicker(context);
                  },
                  child: CircleAvatar(
                    radius: 55,
                    child: _image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.file(
                              _image!,
                              width: 250,
                              height: 250,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(
                                100,
                              ),
                            ),
                            width: 200,
                            height: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey[600],
                                  size: 40,
                                ),

                                Text(
                                  'Upload photo',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
    );
  }
}
