import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:workspace/app/theme/app_dimensions.dart';
import 'package:workspace/models/hive/pet.dart';
import 'package:workspace/pets/components/pet_img_container.dart';
import 'package:workspace/pets/components/pet_tile_action.dart';
import 'package:workspace/provider/pet_provider.dart';
import 'package:workspace/util/app_logger.dart';

class PetTile extends StatelessWidget {
  final ScrollController scrollController;

  const PetTile({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Consumer<PetProvider>(
      builder: (context, value, child) {
        bool isEmpty = value.pets.isEmpty;
        final petList = value.pets;

        return Container(
          height: screenHeight * petListHeightMult,
          padding: EdgeInsets.only(left: 8),
          child: ListView.builder(
            controller: scrollController,
            itemCount: isEmpty ? 1 : petList.length,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 10),
            itemBuilder: (context, index) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  double parentHeight = constraints.maxHeight;
                  final pet = isEmpty ? null : petList[index];
                  return Center(
                    child: Container(
                      margin: const EdgeInsets.only(right: petTileMargin),
                      width: screenWidth * petTileWidthMult,
                      height: parentHeight * petTileHeightMult,
                      decoration: BoxDecoration(
                        color: isEmpty
                            ? Theme.of(context).colorScheme.primaryContainer
                            : pet!.gender == 'M'
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: brMedium,
                      ),

                      child: isEmpty
                          ? _buildEmptyState(context)
                          : _buildPetState(context, pet!),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
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
                      color: Theme.of(
                        context,
                      ).floatingActionButtonTheme.extendedTextStyle!.color,
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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      onTap: () {
        appLogger.i("Pet selected ${pet.toString()} with key: ${pet.key}");

        context.pushNamed(
          'pet-info',
          pathParameters: {'petId': pet.key.toString()},
        );
      },

      onLongPress: () => showModalBottomSheet(
        context: context,
        builder: (sheetContext) {
          final messenger = ScaffoldMessenger.of(context);

          return PetTileAction(
            onDelete: () {
              Navigator.of(
                context,
                rootNavigator: true,
              ).pop(); //close confirmation dialog
              Navigator.of(sheetContext).pop(); //close PetTileAction
              context.read<PetProvider>().deletePet(pet);
              messenger.showSnackBar(
                const SnackBar(
                  content: Text('Pet deleted successfully!'),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 3),
                ),
              );
            },
          );
        },
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
            child: PetImageContainer(petId: pet.key),
          ),
        ],
      ),
    );
  }
}
