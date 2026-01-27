import 'package:flutter/widgets.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:workspace/data/models/hive/pet.dart';

class PetProvider extends ChangeNotifier {
  final Box<Pet> _petBox = Hive.box<Pet>('pets');

  List<Pet> get pets => _petBox.values.toList();
  int get count => _petBox.length;

  PetProvider() {
    _petBox.listenable().addListener(notifyListeners);
  }

  @override
  void dispose() {
    _petBox.listenable().removeListener(notifyListeners);
    super.dispose();
  }

  void addPet(Pet pet) async {
    int key = await _petBox.add(pet);
    pet.id = key;
    await pet.save();
  }

  void updatePet(Pet originalPet, Pet updatedPet) {
    _petBox.put(originalPet.key, updatedPet);
  }

  void deletePet(Pet pet) {
    pet.delete();
  }

  Pet? getPetByKey(dynamic key) {
    final actualKey = key is String ? int.tryParse(key) : key;
    return _petBox.get(actualKey);
  }
}
