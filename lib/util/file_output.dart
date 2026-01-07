import 'dart:io';

import 'package:logger/logger.dart';

class AppFileOutput extends LogOutput {
  final File file;

  AppFileOutput(this.file);

  @override
  void output(OutputEvent event) async {
    for (var line in event.lines) {
      await file.writeAsString("$line\n", mode: FileMode.writeOnlyAppend);
    }
  }
}
