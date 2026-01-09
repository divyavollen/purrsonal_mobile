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
    return GestureDetector(
      onTap: () {
        showPicker?.call(context);
      },
      child: CircleAvatar(
        radius: 55,
        child: image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.file(
                  image!,
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(
                    100,
                  ),
                ),
                width: 200,
                height: 200,

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      color: Colors.grey[600],
                      size: 40,
                    ),

                    Text(
                      'Upload photo',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
