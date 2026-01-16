import 'dart:convert';

import 'package:hive_ce/hive_ce.dart';

part 'pet.g.dart';

@HiveType(typeId: 0)
class Pet extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String species;

  @HiveField(2)
  String? breed;

  @HiveField(3)
  String gender;

  @HiveField(4)
  int? birthdayMillis;

  @HiveField(5)
  String? imagePath;

  Pet({
    required this.name,
    required this.species,
    required this.breed,
    required this.gender,
    required this.birthdayMillis,
    this.imagePath,
  });

  Pet.empty({
    this.name = '',
    this.species = '',
    this.breed,
    this.birthdayMillis = -1,
    this.gender = '',
    this.imagePath,
  });

  @override
  String toString() {
    return 'Pet(name: $name, species: $species, breed: $breed, gender: $gender, birthdayMillis: $birthdayMillis, imagePath: $imagePath)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'species': species,
      'breed': breed,
      'gender': gender,
      'birthdayMillis': birthdayMillis,
      'imagePath': imagePath,
    };
  }

  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
      name: map['name'] as String,
      species: map['species'] as String,
      breed: map['breed'] as String,
      gender: map['gender'] as String,
      birthdayMillis: map['birthdayMillis'] as int,
      imagePath: map['imagePath'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Pet.fromJson(String source) =>
      Pet.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant Pet other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.species == species &&
        other.breed == breed &&
        other.gender == gender &&
        other.birthdayMillis == birthdayMillis &&
        other.imagePath == imagePath;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        species.hashCode ^
        breed.hashCode ^
        gender.hashCode ^
        birthdayMillis.hashCode ^
        imagePath.hashCode;
  }

  Pet copyWith({
    String? name,
    String? species,
    String? breed,
    String? gender,
    int? birthdayMillis,
    String? imagePath,
  }) {
    return Pet(
      name: name ?? this.name,
      species: species ?? this.species,
      breed: breed ?? this.breed,
      gender: gender ?? this.gender,
      birthdayMillis: birthdayMillis ?? this.birthdayMillis,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
