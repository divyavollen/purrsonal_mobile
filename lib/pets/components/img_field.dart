import 'dart:io';

import 'package:flutter/material.dart';

class ImageField extends StatelessWidget {
  final File? image;
  final Function(BuildContext)? showPicker;
  final Function(BuildContext)? showClearImage;

  const ImageField({
    super.key,
    this.image,
    this.showPicker,
    this.showClearImage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Upload photo',
          filled: false,
        ),
        child: GestureDetector(
          onTap: () {
            showPicker?.call(context);
          },

          child: CircleAvatar(
            radius: 90,
            backgroundImage: image != null ? FileImage(image!) : null,
            backgroundColor: Colors.transparent,
            child: image == null
                ? Icon(
                    Icons.camera_alt,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 40,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
