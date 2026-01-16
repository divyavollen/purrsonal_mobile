import 'dart:io';

import 'package:flutter/material.dart';
import 'package:workspace/app/theme/app_dimensions.dart';

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
                : Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    width: petFormImgSize,
                    height: petFormImgSize,

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          size: 40,
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
