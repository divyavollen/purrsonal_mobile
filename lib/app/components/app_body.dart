import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:workspace/app/components/app_dimensions.dart';
import 'package:workspace/data/pet_database.dart';
import 'package:workspace/models/pet.dart';
import 'package:workspace/pets/pet_tile.dart';

class AppBody extends StatefulWidget {
  const AppBody({super.key});

  @override
  AppBodyState createState() => AppBodyState();
}

class AppBodyState extends State<AppBody> {
  late PetDatabase petDb;
  late List<Pet> petList;
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> _scrollOffset = ValueNotifier<double>(0.0);
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    final Box<Pet> petBox = Hive.box<Pet>('pets');
    petDb = PetDatabase(petBox);
    petList = petDb.petList;
    _scrollController.addListener(() {
      _scrollOffset.value = _scrollController.offset;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollOffset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(width: 18),

              Text(
                'Your Pets',
                style: Theme.of(context).textTheme.headlineSmall,
              ),

              SizedBox(width: 8),

              Icon(FontAwesomeIcons.paw, size: 18),
            ],
          ),

          ValueListenableBuilder(
            valueListenable: Hive.box<Pet>('pets').listenable(),
            builder: (BuildContext context, Box<Pet> box, Widget? child) {
              final currentPets = box.values.toList();
              return Column(
                children: [
                  Container(
                    height: screenHeight * petListHeightMult,
                    padding: EdgeInsets.only(left: 8),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: currentPets.isEmpty ? 1 : currentPets.length,
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(left: 10),
                      itemBuilder: (context, index) {
                        if (currentPets.isEmpty) {
                          return PetTile.empty();
                        }

                        final pet = currentPets[index];
                        return PetTile(
                          pet: pet,
                          onDelete: () => pet.delete(),
                          isSelected: _selectedIndex == index,
                          onTap: () => _handleTileTap(index),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 20),

                  if (_selectedIndex != -1 && currentPets.isNotEmpty)
                    Container(
                      height: screenHeight * petDetailHeightMult,
                      width: screenWidth * 0.9,
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,

                        borderRadius: BorderRadius.circular(
                          12,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 10,
                            spreadRadius: 1,
                            offset: Offset(0, 0),
                            blurStyle: BlurStyle.outer,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Text(
                            currentPets[_selectedIndex].name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  void _handleTileTap(int index) {
    setState(() => _selectedIndex = index);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double tileWidthWithMargin =
        (screenWidth * petTileWidthMult) + petTileMargin;

    final double offset = index * tileWidthWithMargin;

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        offset.clamp(0.0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }
}
