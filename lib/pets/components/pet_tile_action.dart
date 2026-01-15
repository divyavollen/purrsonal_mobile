import 'package:flutter/material.dart';
import 'package:workspace/app/components/confirmation_alert.dart';

class PetTileAction extends StatelessWidget {
  final Function onDelete;
  const PetTileAction({super.key, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom > 0
        ? 0
        : 10.0;

    //TODO make reusable bottom sheet
    return SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.admin_panel_settings),
            title: Text('Manage Pet'),
            contentPadding: EdgeInsets.only(
              left: 25.0,
              top: 10.0,
              bottom: 10.0,
            ),
            onTap: () {},
          ),

          ListTile(
            leading: Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(
              'Delete Pet',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            contentPadding: EdgeInsets.only(left: 25.0, bottom: bottomPadding),
            onTap: () => ConfirmationAlertDialog.showConfirmation(
              context,
              button1: 'Cancel',
              button2: 'Continue',
              confirmationMessage: 'Are you sure you want to delete this pet?',
              icon: Icons.warning,
              onPressed: () => onDelete,
            ),
          ),
        ],
      ),
    );
  }
}
