import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workspace/util/file_output.dart';

late Logger appLogger;

class AppLogger {
  Future<void> init() async {
    final directory = await getExternalStorageDirectory();

    final file = File('${directory?.path}/app_logs.txt');

    appLogger = Logger(
      level: Level.debug,

      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: false,
        printEmojis: false,
        dateTimeFormat: DateTimeFormat.dateAndTime,
      ),

      output: MultiOutput([
        ConsoleOutput(),
        AppFileOutput(file),
      ]),
    );
  }
}
