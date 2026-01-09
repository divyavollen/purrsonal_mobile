import 'dart:io';

import 'package:flutter/material.dart';

class PetImagePicker extends StatelessWidget {
  final File? image;
  final Function(BuildContext)? showPicker;

  const PetImagePicker({
    super.key,
    this.image,
    this.showPicker,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Upload Photo',
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            showPicker?.call(context);
          },
          child: CircleAvatar(
            radius: 90,
            backgroundColor: Colors.transparent,
            child: image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(90),
                    child: Image.file(
                      image!,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(90),
                    ),
                    width: 150,
                    height: 150,

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          color: Colors.grey[600],
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
