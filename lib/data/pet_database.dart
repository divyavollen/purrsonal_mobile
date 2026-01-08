import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:workspace/models/pet.dart';
import 'package:workspace/util/app_logger.dart';

class PetDatabase {
  final Box<Pet> _petBox;
  Box? _settingsBox;

  PetDatabase(this._petBox, this._settingsBox);

  PetDatabase.pet(this._petBox);

  List<Pet> get petList => _petBox.values.toList();

  void createInitialData() {
    List<Pet> initialPets = [
      Pet(
        name: "Pixel",
        species: "Cat",
        breed: "Unknown",
        birthdayMillis: 1766663400000,
        gender: 'M',
        imagePath: 'assets/images/pexels.jpg',
      ),
      Pet(
        name: "Millie",
        species: "Cat",
        breed: "Unknown",
        birthdayMillis: 1672531200000,
        gender: 'F',
        imagePath: 'assets/images/millie.jpg',
      ),
      Pet(
        name: "Pookie",
        species: "Cat",
        breed: "Unknown",
        birthdayMillis: 1641031200000,
        gender: 'F',
        imagePath: 'assets/images/pookie.jpg',
      ),
      Pet(
        name: "Bingus",
        species: "Cat",
        breed: "Unknown",
        birthdayMillis: 1641031200000,
        gender: 'M',
        imagePath: 'assets/images/bingus.jpg',
      ),
    ];

    _petBox.addAll(initialPets);
    _settingsBox?.put('is_first_run', false);
    logger.i('Initialised pets: $initialPets');
  }

  void addNewPet(Pet pet) {
    logger.i('Adding new pet: $pet');

    _petBox.add(pet);
  }
}
