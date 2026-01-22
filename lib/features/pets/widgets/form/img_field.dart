import 'dart:io';

import 'package:flutter/material.dart';
import 'package:workspace/core/constants/app_dimensions.dart';

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
            backgroundColor: Colors.transparent,
            child: image != null
                ? ClipOval(
                    child: Image.file(
                      image!,
                      width: petFormImgSize,
                      height: petFormImgSize,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(Icons.camera_alt, size: 40),
          ),
        ),
      ),
    );
  }
}
