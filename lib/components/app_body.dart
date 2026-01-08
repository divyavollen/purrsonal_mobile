import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:workspace/components/pet_tile.dart';
import 'package:workspace/data/pet_database.dart';
import 'package:workspace/models/pet.dart';

class AppBody extends StatefulWidget {
  const AppBody({super.key});

  @override
  State<AppBody> createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  late PetDatabase petDb;
  late List<Pet> petList;

  @override
  void initState() {
    super.initState();
    final Box<Pet> petBox = Hive.box<Pet>('pets');
    final Box settingsBox = Hive.box('settings');
    petDb = PetDatabase(petBox, settingsBox);

    bool isFirstRun = settingsBox.get('is_first_run', defaultValue: true);

    if (isFirstRun) {
      petDb.createInitialData();
    }

    petList = petDb.petList;
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

          ValueListenableBuilder(
            valueListenable: Hive.box<Pet>('pets').listenable(),
            builder: (BuildContext context, Box<Pet> box, Widget? child) {
              final currentPets = box.values.toList();

              return SizedBox(
                height: screenHeight * 0.3,
                child: ListView.builder(
                  itemCount: currentPets.isEmpty ? 1 : currentPets.length,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 10),
                  itemBuilder: (context, index) {
                    if (currentPets.isEmpty) {
                      return const PetTile.empty();
                    }

                    final pet = currentPets[index];
                    return PetTile(
                      pet: pet,
                      index: index,
                      onDelete: (context) {
                        pet.delete();
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
