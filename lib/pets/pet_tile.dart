import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

              return Center(
                child: Container(
                  margin: const EdgeInsets.only(right: petTileMargin),
                  width: screenWidth * petTileWidthMult,
                  height: parentHeight * petTileHeightMult,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: brMedium,
                  ),

                  child: isEmpty
                      ? _buildEmptyState(context)
                      : _buildPetState(context, petList![index]),
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
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 3.0),
            child: Text.rich(
              TextSpan(
                children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Icon(
                      FontAwesomeIcons.solidHeart,
                      size: 12,
                      color: Theme.of(
                        context,
                      ).colorScheme.tertiaryContainer,
                    ),
                  ),
                  TextSpan(
                    text: ' ${pet.name} ',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Icon(
                      FontAwesomeIcons.solidHeart,
                      size: 12,
                      color: Theme.of(
                        context,
                      ).colorScheme.tertiaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            height: petTileImgSize,
            width: petTileImgSize,
            decoration: BoxDecoration(
              border: Border.all(
                color: pet.gender == 'M'
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.secondary,
                width: 3,
              ),
              shape: BoxShape.circle,
            ),

            child: ClipOval(
              child: Container(
                decoration: BoxDecoration(
                  color: hasNoImage
                      ? Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: hasNoImage
                    ? Icon(
                        Icons.image_not_supported,
                        size: 50,
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
        ],
      ),
    );
  }
}
