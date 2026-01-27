// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive_ce/hive_ce.dart';

part 'pet.g.dart';

@HiveType(typeId: 0)
class Pet extends HiveObject {
  @HiveField(0)
  dynamic id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String species;

  @HiveField(3)
  String? breed;

  @HiveField(4)
  String gender;

  @HiveField(5)
  int? birthdayMillis;

  @HiveField(6)
  String? imagePath;

  Pet({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.gender,
    required this.birthdayMillis,
    this.imagePath,
  });

  Pet.empty({
    this.id,
    this.name = '',
    this.species = '',
    this.breed,
    this.birthdayMillis = -1,
    this.gender = '',
    this.imagePath,
  });

  @override
  String toString() {
    return 'Pet(id: $id, name: $name, species: $species, breed: $breed, gender: $gender, birthdayMillis: $birthdayMillis, imagePath: $imagePath)';
  }

  Pet copyWith({
    String? id,
    String? name,
    String? species,
    String? breed,
    String? gender,
    int? birthdayMillis,
    String? imagePath,
  }) {
    return Pet(
      id: id ?? this.id,
      name: name ?? this.name,
      species: species ?? this.species,
      breed: breed ?? this.breed,
      gender: gender ?? this.gender,
      birthdayMillis: birthdayMillis ?? this.birthdayMillis,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
