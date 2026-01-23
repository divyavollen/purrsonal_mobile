import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:workspace/data/models/hive/pet.dart';
import 'package:workspace/features/pets/providers/calendar_selection_provider.dart';
import 'package:workspace/features/pets/providers/pet_provider.dart';
import 'package:workspace/features/pets/widgets/calendar/appointment_editor.dart';

class PetDetails extends StatelessWidget {
  final String petId;
  final StatefulNavigationShell navigationShell;

  const PetDetails({
    super.key,
    required this.petId,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    final pet = context.select<PetProvider, Pet?>(
      (provider) => provider.getPetByKey(petId),
    );

    if (pet == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        titleSpacing: -5,
        title: Text(pet.name),
        leading: IconButton(
          onPressed: () => context.goNamed('home'),
          icon: Icon(Icons.close),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: navigationShell,
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: const [
          NavigationDestination(label: 'Pet', icon: Icon(FontAwesomeIcons.paw)),
          NavigationDestination(
            label: 'Calendar',
            icon: Icon(Icons.calendar_month),
          ),
        ],
        onDestinationSelected: (value) => navigationShell.goBranch(value),
      ),

      floatingActionButton: navigationShell.currentIndex == 1
          ? FloatingActionButton(
              onPressed: () async {
                final selectedDate = context
                    .read<CalendarSelectionProvider>()
                    .selectedDate;

                await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AppointmentEditor(
                    selectedDate: selectedDate,
                    petId: petId,
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
