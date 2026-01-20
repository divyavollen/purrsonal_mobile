import 'package:flutter/material.dart';
import 'package:workspace/core/widgets/confirmation_alert.dart';
import 'package:workspace/core/widgets/custom_bottom_sheet.dart';
import 'package:workspace/data/models/sheet_item.dart';

class PetTileAction extends StatelessWidget {
  final Function onDelete;
  const PetTileAction({super.key, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom > 0
        ? 0
        : 10.0;

    return CustomBottomSheet(
      items: [
        SheetItem(
          leading: Icon(Icons.admin_panel_settings),
          title: Text('Manage Pet'),
          onTap: () {},
          padding: EdgeInsets.only(left: 25.0, top: 10.0, bottom: 10.0),
        ),
        SheetItem(
          leading: Icon(
            Icons.delete,
            color: Theme.of(context).colorScheme.error,
          ),
          title: Text('Delete Pet'),
          onTap: () => ConfirmationAlertDialog.showConfirmation(
            context,
            button1: 'CANCEL',
            button2: 'DELETE',
            confirmationMessage: 'Are you sure you want to delete this pet?',
            icon: Icons.warning,
            onPressed: () => onDelete(),
          ),
          padding: EdgeInsets.only(left: 25.0, bottom: bottomPadding),
        ),
      ],
    );
  }
}
