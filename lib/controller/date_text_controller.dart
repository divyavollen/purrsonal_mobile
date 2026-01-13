import 'package:flutter/material.dart';

class DateTextEditingController extends TextEditingController {
  int milliseconds = 0;

  @override
  String toString() =>
      'DateTextEditingController(milliseconds: $milliseconds text: $text)';
}
