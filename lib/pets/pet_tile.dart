import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:workspace/app/components/app_dimensions.dart';
import 'package:workspace/models/pet.dart';
import 'package:workspace/util/app_logger.dart';

class PetTile extends StatelessWidget {
  final Pet? pet;
  final VoidCallback? onDelete;
  final bool isEmpty;
  final VoidCallback? onTap;
  final bool isSelected;

  const PetTile({
    super.key,
    required this.pet,
    required this.onDelete,
    this.onTap,
    this.isSelected = false,
  }) : isEmpty = false;

  const PetTile.empty({
    super.key,
  }) : pet = null,
       onDelete = null,
       isEmpty = true,
       onTap = null,
       isSelected = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return LayoutBuilder(
      builder: (context, constraints) {
        double parentHeight = constraints.maxHeight;

        return Center(
          child: AnimatedContainer(
            duration: const Duration(
              milliseconds: 300,
            ),
            margin: const EdgeInsets.only(right: petTileMargin),
            width: screenWidth * petTileWidthMult,
            height: parentHeight * petTileHeightMult,
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.tertiaryContainer
                  : Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),

            child: isEmpty
                ? _buildEmptyState(context)
                : _buildPetState(context),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageIcon(
            AssetImage('assets/images/pets.png'),
            size: 50,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 15),
          Text(
            "No furry friends yet!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Add your first pet to see them here.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  void askDeleteConfirmation(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      onPressed: () => Navigator.pop(context),
    );

    Widget continueButton = TextButton(
      child: Text(
        "Continue",
        style: TextStyle(
          color: Theme.of(context).colorScheme.error,
        ),
      ),
      onPressed: () {
        onDelete?.call();
        Navigator.pop(context);
        final routeBehind = ModalRoute.of(context);
        if (routeBehind is PopupRoute) {
          Navigator.pop(context);
        }
      },
    );

    AlertDialog alert = AlertDialog(
      title: Icon(
        Icons.warning,
        size: 30,
        color: Theme.of(context).colorScheme.error,
      ),
      content: Text(
        "Are you sure you want to delete this pet?",
        style: Theme.of(context).textTheme.titleSmall,
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _buildPetState(BuildContext context) {
    bool hasNoImage = pet!.imagePath == null || pet!.imagePath!.trim().isEmpty;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      //async {
      //EDIT PET
      // await showDialog(
      //   context: context,
      //   builder: (context) => PetWidget(
      //     mode: 'edit',
      //     pet: pet,
      //     onDelete: (ctx) => askDeleteConfirmation(ctx),
      //   ),
      //   barrierDismissible: false,
      //   useSafeArea: false,
      // );
      //},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsetsGeometry.only(top: 10.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: pet?.gender == 'M'
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.tertiary,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(100),
              ),

              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  height: 80.0,
                  width: 80.0,
                  decoration: BoxDecoration(
                    color: hasNoImage
                        ? Theme.of(context).colorScheme.surfaceContainerHighest
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: hasNoImage
                      ? Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : FutureBuilder<Directory>(
                          future: getApplicationDocumentsDirectory(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final String fullPath = p.join(
                                snapshot.data!.path,
                                pet!.imagePath!,
                              );

                              return Image.file(
                                File(fullPath),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  appLogger.e(
                                    "Image missing at: $fullPath",
                                    error: error,
                                    stackTrace: stackTrace,
                                  );
                                  return const Icon(
                                    Icons.broken_image,
                                    size: 50,
                                  );
                                },
                              );
                            }
                            return const CircularProgressIndicator();
                          },
                        ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 10.0),
            child: Row(
              children: [
                pet?.gender == 'M'
                    ? Icon(
                        Icons.male,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : Icon(
                        Icons.female,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),

                const SizedBox(width: 3),

                Text(pet!.name),

                Spacer(),

                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  onPressed: () => askDeleteConfirmation(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
