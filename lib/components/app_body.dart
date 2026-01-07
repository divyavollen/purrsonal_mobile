import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:workspace/components/pet_tile.dart';
import 'package:workspace/data/pet_database.dart';
import 'package:workspace/models/pet.dart';
import 'package:workspace/util/app_logger.dart';

class AppBody extends StatefulWidget {
  const AppBody({super.key});

  @override
  State<AppBody> createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  late PetDatabase petDb;

  @override
  void initState() {
    final Box<Pet> petBox = Hive.box<Pet>('pets');
    final Box settingsBox = Hive.box('settings');
    petDb = PetDatabase(petBox, settingsBox);

    bool isFirstRun = settingsBox.get('is_first_run', defaultValue: true);

    if (isFirstRun) {
      petDb.createInitialData();
    } else {
      petDb.loadPets();
    }
    super.initState();
  }

  void deletePet(int index) {
    logger.i("Deleting pet ${petDb.petList[index]}");
    setState(() {
      petDb.petList.removeAt(index);
    });
    petDb.updatePets();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(width: 10),

              Text(
                'Your Pets',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),

              SizedBox(width: 8),

              Icon(FontAwesomeIcons.paw, size: 18),
            ],
          ),

          SizedBox(height: 10),

          SizedBox(
            height: screenHeight * 0.32,
            child: ListView.builder(
              itemCount: petDb.petList.isEmpty ? 1 : petDb.petList.length,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: 10),
              itemBuilder: (context, index) {
                if (petDb.petList.isEmpty) {
                  return const PetTile.empty();
                }

                final pet = petDb.petList[index];
                return PetTile(
                  pet: pet,
                  index: index,
                  onDelete: (context) => deletePet(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
