import 'package:hive_ce/hive_ce.dart';

part 'pet.g.dart';

@HiveType(typeId: 0)
class Pet {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int birthdayMillis;

  @HiveField(2)
  final String sex;

  @HiveField(3)
  final String imagePath;

  Pet({
    required this.name,
    required this.birthdayMillis,
    required this.sex,
    required this.imagePath,
  });

  @override
  String toString() {
    return 'Pet(name: $name, birthdayMillis: $birthdayMillis, sex: $sex, imagePath: $imagePath)';
  }
}
