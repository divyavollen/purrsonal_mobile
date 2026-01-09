import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  final Future<void> Function(ImageSource source) pickImage;

  const ImageSourceSheet({
    super.key,
    required this.pickImage,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.photo_library),
            title: Text(
              'Photo Library',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            iconColor: Colors.grey[600],
            contentPadding: EdgeInsets.only(left: 25.0, top: 10.0),
            onTap: () {
              pickImage(ImageSource.gallery);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: Icon(Icons.photo_camera),
            title: Text(
              'Camera',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            iconColor: Colors.grey[600],
            contentPadding: EdgeInsets.only(left: 25.0),
            onTap: () {
              pickImage(ImageSource.camera);
              Navigator.of(context).pop();
            },
          ),

          ListTile(
            leading: Icon(Icons.cancel),
            title: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            iconColor: Colors.grey[600],
            contentPadding: EdgeInsets.only(left: 25.0, bottom: 10.0),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
