import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:workspace/models/pet.dart';
import 'package:workspace/util/app_logger.dart';

class PetDatabase {
  final Box<Pet> _petBox;
  final Box _settingsBox;

  PetDatabase(this._petBox, this._settingsBox);

  List<Pet> petList = [];

  void createInitialData() async {
    petList = [
      Pet(
        name: "Pixel",
        birthdayMillis: 1766663400000,
        sex: 'M',
        imagePath: 'assets/images/pexels.jpg',
      ),
      Pet(
        name: "Millie",
        birthdayMillis: 1672531200000,
        sex: 'F',
        imagePath: 'assets/images/millie.jpg',
      ),
      Pet(
        name: "Pookie",
        birthdayMillis: 1641031200000,
        sex: 'F',
        imagePath: 'assets/images/pookie.jpg',
      ),
      Pet(
        name: "Bingus",
        birthdayMillis: 1641031200000,
        sex: 'M',
        imagePath: 'assets/images/bingus.jpg',
      ),
    ];

    await _petBox.addAll(petList);
    await _settingsBox.put('is_first_run', false);
    logger.i('Initialised pets: $petList');
  }

  void loadPets() {
    petList = _petBox.values.toList();
    logger.i('Loaded ${petList.length} pets');
  }

  void updatePets() async {
    await _petBox.clear();
    await _petBox.addAll(petList);
    logger.i('Box updated with ${petList.length} items');
  }
}
