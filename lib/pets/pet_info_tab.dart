import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:workspace/app/components/confirmation_alert.dart';
import 'package:workspace/app/theme/app_dimensions.dart';
import 'package:workspace/models/hive/pet.dart';
import 'package:workspace/pets/components/pet_img_container.dart';
import 'package:workspace/pets/pet_form.dart';
import 'package:workspace/provider/pet_provider.dart';
import 'package:workspace/util/app_logger.dart';
import 'package:workspace/util/date_util.dart';

class PetInfoTab extends StatelessWidget {
  final String petId;
  const PetInfoTab({super.key, required this.petId});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Selector<PetProvider, Pet?>(
      selector: (_, provider) => provider.getPetByKey(petId),
      builder: (context, pet, child) {
        if (pet == null) return const SizedBox.shrink();

        String age = DateUtil().getAge(pet.birthdayMillis);

        return Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: screenWidth,
            height: screenHeight * 0.2,
            decoration: BoxDecoration(
              borderRadius: brSmall,
              color: pet.gender == 'M' || pet.gender.isEmpty
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.secondaryContainer,
            ),
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: PetImageContainer(petId: pet.key),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildInfo(
                            context,
                            pet.name,
                          ),
                          _buildInfo(
                            context,
                            age,
                          ),
                          _buildInfo(
                            context,
                            DateUtil().formatDate(pet.birthdayMillis),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Positioned(
                  bottom: 0,
                  right: 0,
                  child: TextButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (editFormContext) => PetForm.edit(
                        pet: pet,
                        onDelete: (petFormContext) {
                          appLogger.i('user wants to delete pet');
                          ConfirmationAlertDialog.showConfirmation(
                            context,
                            button1: 'CANCEL',
                            button2: 'DELETE',
                            icon: Icons.warning,
                            confirmationMessage:
                                'Are you sure you want to delete this pet?',
                            onPressed: () {
                              final NavigatorState rootNav = Navigator.of(
                                context,
                                rootNavigator: true,
                              );
                              final NavigatorState formNav = Navigator.of(
                                editFormContext,
                              );
                              final petProvider = context.read<PetProvider>();
                              final messenger = ScaffoldMessenger.of(context);

                              rootNav.pop(); // Closes confirmation
                              formNav.pop(); // Closes PetForm
                              context.goNamed('home');
                              messenger.showSnackBar(
                                const SnackBar(
                                  content: Text('Pet deleted successfully!'),
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(seconds: 3),
                                ),
                              );

                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                petProvider.deletePet(pet);
                              });
                            },
                          );
                        },
                      ),
                    ),
                    child: Text(
                      'EDIT',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiaryFixed,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfo(BuildContext context, String? text) {
    final displayText = (text == null || text.isEmpty)
        ? ''
        : text.toUpperCase();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 1.0,
          ),
        ),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          letterSpacing: 1.5,
          fontWeight: FontWeight.w600,
          fontSize: smallFontSize,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
