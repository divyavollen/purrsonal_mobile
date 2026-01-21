import 'package:flutter/material.dart';

class CalendarSelectionProvider extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void updateDate(DateTime newDate) {
    _selectedDate = newDate;
    notifyListeners();
  }
}
