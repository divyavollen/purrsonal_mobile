import 'package:flutter/material.dart';
import 'package:workspace/data/models/sheet_item.dart';

class CustomBottomSheet extends StatelessWidget {
  final List<SheetItem> items;

  const CustomBottomSheet({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                leading: item.leading,
                title: item.title,
                contentPadding: item.padding,
                onTap: item.onTap,
              );
            },
          ),
        ],
      ),
    );
  }
}
