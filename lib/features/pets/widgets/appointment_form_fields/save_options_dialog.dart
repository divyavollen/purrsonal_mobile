import 'package:flutter/material.dart';
import 'package:workspace/core/widgets/custom_bottom_sheet.dart';
import 'package:workspace/data/models/sheet_item.dart';

class SaveOptionsDialog extends StatelessWidget {
  const SaveOptionsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom > 0
        ? 0
        : 10.0;

    return CustomBottomSheet(
      items: [
        SheetItem(
          leading: Icon(Icons.event),
          title: Text('Save series'),
          onTap: () => Navigator.pop(context, 'series'),
          padding: EdgeInsets.only(left: 25.0, top: 10.0, bottom: 10.0),
        ),
        SheetItem(
          leading: Icon(Icons.event_repeat),
          title: Text('Save this occurrence'),
          onTap: () => Navigator.pop(context, 'occurrence'),
          padding: EdgeInsets.only(left: 25.0, bottom: bottomPadding),
        ),
      ],
    );
  }
}
