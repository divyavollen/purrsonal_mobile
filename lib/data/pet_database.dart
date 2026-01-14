import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:workspace/models/pet.dart';

class PetDatabase {
  final Box<Pet> _petBox;

  PetDatabase(this._petBox);

  List<Pet> get petList => _petBox.values.toList();

  Future<void> addNewPet(Pet pet) async {
    _petBox.add(pet);
  }

  Pet? getPet(int index) {
    return _petBox.getAt(index);
  }
}
