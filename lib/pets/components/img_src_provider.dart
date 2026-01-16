import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workspace/app/components/custom_bottom_sheet.dart';
import 'package:workspace/models/sheet_item.dart';

class ImageSourceProvider extends StatelessWidget {
  final Future<void> Function(ImageSource source) pickImage;
  final bool isUploaded;
  final Function() clearImage;

  const ImageSourceProvider({
    super.key,
    required this.pickImage,
    required this.isUploaded,
    required this.clearImage,
  });

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom > 0
        ? 0
        : 10.0;

    return CustomBottomSheet(
      items: [
        SheetItem(
          leading: Icon(Icons.photo_library),
          title: Text(isUploaded ? 'Update photo' : 'Choose photo'),
          onTap: () {
            Navigator.of(context).pop();
            pickImage(ImageSource.gallery);
          },
          padding: EdgeInsets.only(left: 25.0, top: 10.0),
        ),
        SheetItem(
          leading: Icon(Icons.photo_camera),
          title: Text('Take photo'),
          onTap: () {
            Navigator.of(context).pop();
            pickImage(ImageSource.camera);
          },
          padding: EdgeInsets.only(left: 25.0),
        ),

        if (isUploaded) ...[
          SheetItem(
            leading: Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(
              'Delete photo',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            onTap: () {
              Navigator.pop(context);
              clearImage();
            },
            padding: EdgeInsets.only(
              left: 25.0,
              bottom: bottomPadding,
            ),
          ),
        ],
      ],
    );
  }
}
