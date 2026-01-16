import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:workspace/models/hive/pet.dart';

class ImageUtil {
  static final ImageUtil _instance = ImageUtil._internal();
  factory ImageUtil() => _instance;
  ImageUtil._internal();

  String? _basePath;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _basePath = dir.path;
  }

  File? getImage(Pet pet) {
    if (pet.imagePath == null || _basePath == null) return null;

    String? fullPath = getImagePath(pet.imagePath);

    return fullPath != null ? File(fullPath) : null;
  }

  String? getImagePath(String? filename) {
    return filename != null ? p.join(_basePath!, filename) : null;
  }
}
