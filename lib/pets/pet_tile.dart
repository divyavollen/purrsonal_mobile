import 'dart:io';

import 'package:flutter/material.dart';
import 'package:workspace/app/theme/app_dimensions.dart';
import 'package:workspace/models/hive/pet.dart';
import 'package:workspace/pets/components/pet_tile_action.dart';
import 'package:workspace/util/app_logger.dart';
import 'package:workspace/util/image_util.dart';

class PetTile extends StatelessWidget {
  final List<Pet>? petList;
  final ScrollController scrollController;

  const PetTile({
    super.key,
    this.petList,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    bool isEmpty = petList == null || petList!.isEmpty;

    return Container(
      height: screenHeight * petListHeightMult,
      padding: EdgeInsets.only(left: 8),
      child: ListView.builder(
        controller: scrollController,
        itemCount: isEmpty ? 1 : petList!.length,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: 10),
        itemBuilder: (context, index) {
          return LayoutBuilder(
            builder: (context, constraints) {
              double parentHeight = constraints.maxHeight;
              final pet = petList![index];
              return Center(
                child: Container(
                  margin: const EdgeInsets.only(right: petTileMargin),
                  width: screenWidth * petTileWidthMult,
                  height: parentHeight * petTileHeightMult,
                  decoration: BoxDecoration(
                    color: pet.gender == 'M'
                        ? Theme.of(context).colorScheme.primaryContainer
                        : Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: brMedium,
                  ),

                  child: isEmpty
                      ? _buildEmptyState(context)
                      : _buildPetState(context, pet),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageIcon(
            AssetImage('assets/images/pets.png'),
            size: noPetsIconSize,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 15),
          Text(
            "No furry friends yet!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: subTextFontSize,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),

          Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: buttonTextFontSize,
              ),
              children: [
                TextSpan(
                  text: 'Tap ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).floatingActionButtonTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 15,
                    ),
                  ),
                ),
                TextSpan(
                  text: ' to add a new pet.',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetState(BuildContext context, Pet pet) {
    File? imageFile = ImageUtil().getImage(pet);
    bool hasNoImage = pet.imagePath == null || pet.imagePath!.trim().isEmpty;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      onTap: () => Navigator.pushNamed(
        context,
        '/pet',
        arguments: pet,
      ),

      onLongPress: () => showModalBottomSheet(
        context: context,
        builder: (context) => PetTileAction(
          onDelete: () {
            Navigator.pop(context);
            Navigator.pop(context);
            pet.delete();
          },
        ),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Material(
            elevation: 2,
            shadowColor: Theme.of(context).colorScheme.outline,
            child: SizedBox(
              width: double.infinity,
              child: Text(
                pet.name.toUpperCase(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 3.0),
            child: SizedBox(
              height: petTileImgSize,
              width: petTileImgSize,
              child: ClipOval(
                child: Container(
                  decoration: BoxDecoration(
                    color: hasNoImage
                        ? Theme.of(
                            context,
                          ).colorScheme.surfaceContainer
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: hasNoImage
                      ? Icon(
                          Icons.image_not_supported,
                          size: noPetsIconSize,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : Image.file(
                          imageFile!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            appLogger.e(
                              "Image missing :",
                              error: error,
                              stackTrace: stackTrace,
                            );
                            return const Icon(
                              Icons.broken_image,
                              size: 50,
                            );
                          },
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
