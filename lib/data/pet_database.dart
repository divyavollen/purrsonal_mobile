import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:workspace/models/pet.dart';
import 'package:workspace/util/app_logger.dart';

class PetDatabase {
  final Box<Pet> _petBox;

  PetDatabase(this._petBox);

  List<Pet> get petList => _petBox.values.toList();

  void addNewPet(Pet pet) {
    appLogger.i('Adding new pet: $pet');

    _petBox.add(pet);
  }

  Pet? getPet(int index) {
    return _petBox.getAt(index);
  }
}
