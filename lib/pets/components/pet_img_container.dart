import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workspace/app/theme/app_dimensions.dart';
import 'package:workspace/models/hive/pet.dart';
import 'package:workspace/provider/pet_provider.dart';
import 'package:workspace/util/app_logger.dart';
import 'package:workspace/util/image_util.dart';

class PetImageContainer extends StatelessWidget {
  final dynamic petId;
  const PetImageContainer({super.key, required this.petId});

  @override
  Widget build(BuildContext context) {
    final pet = context.select<PetProvider, Pet?>(
      (provider) => provider.getPetByKey(petId),
    );

    File? imageFile = ImageUtil().getImage(pet!);
    bool hasNoImage = pet.imagePath == null || pet.imagePath!.trim().isEmpty;

    return SizedBox(
      height: petTileImgSize,
      width: petTileImgSize,
      child: ClipOval(
        child: Container(
          decoration: BoxDecoration(
            color: hasNoImage
                ? Theme.of(
                    context,
                  ).colorScheme.surfaceContainer
                : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: hasNoImage
              ? Icon(
                  Icons.image_not_supported,
                  size: noPetsIconSize,
                  color: Theme.of(context).colorScheme.primary,
                )
              : Image.file(
                  imageFile!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    appLogger.e(
                      "Image missing :",
                      error: error,
                      stackTrace: stackTrace,
                    );
                    return const Icon(
                      Icons.broken_image,
                      size: 50,
                    );
                  },
                ),
        ),
      ),
    );
  }
}
