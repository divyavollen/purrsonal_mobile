import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

    return SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text(
              isUploaded ? 'Update photo' : 'Choose photo',
            ),
            contentPadding: EdgeInsets.only(left: 25.0, top: 10.0),
            onTap: () {
              Navigator.of(context).pop();
              pickImage(ImageSource.gallery);
            },
          ),

          ListTile(
            leading: Icon(Icons.photo_camera),
            title: Text(
              'Take photo',
            ),
            contentPadding: EdgeInsets.only(left: 25.0),
            onTap: () {
              Navigator.of(context).pop();
              pickImage(ImageSource.camera);
            },
          ),

          if (isUploaded) ...[
            const Divider(indent: 25, endIndent: 25),
            ListTile(
              leading: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text(
                'Delete photo',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              contentPadding: EdgeInsets.only(
                left: 25.0,
                bottom: bottomPadding,
              ),
              onTap: () {
                Navigator.pop(context);
                clearImage();
              },
            ),
          ],
        ],
      ),
    );
  }
}
