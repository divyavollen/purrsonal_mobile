import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:workspace/core/utils/app_logger.dart';
import 'package:workspace/data/models/hive/pet_appointment.dart';

class PetAppointmentProvider extends ChangeNotifier {
  final Box<PetAppointment> _evtBox = Hive.box<PetAppointment>('appointments');

  List<PetAppointment> get events => _evtBox.values.toList();
  int get count => _evtBox.length;

  PetAppointmentProvider() {
    _evtBox.listenable().addListener(notifyListeners);
  }

  @override
  void dispose() {
    _evtBox.listenable().removeListener(notifyListeners);
    super.dispose();
  }

  Future<void> addEvent(PetAppointment newAppt) async {
    int key = await _evtBox.add(newAppt);
    newAppt.id = key;
    await newAppt.save();
  }

  Future<void> updateEvent(
    PetAppointment originalEvent,
    PetAppointment updatedEvent,
  ) async {
    _evtBox.put(originalEvent.key, updatedEvent);
  }

  Future<void> deleteEvent(PetAppointment event) async {
    final masterId = event.id;

    final exceptionKeys = _evtBox.keys.where((k) {
      final e = _evtBox.get(k);
      return e?.recurrenceId == masterId;
    }).toList();

    if (exceptionKeys.isNotEmpty) {
      await _evtBox.deleteAll(exceptionKeys);
    }

    await event.delete();
  }

  Future<void> deleteOccurrence(
    PetAppointment master,
    DateTime selectedDate,
  ) async {
    final List<DateTime> currentExclusions = List<DateTime>.from(
      master.exceptionDates ?? [],
    );

    final bool isAlreadyExcluded = currentExclusions.any(
      (d) =>
          d.year == selectedDate.year &&
          d.month == selectedDate.month &&
          d.day == selectedDate.day &&
          d.hour == selectedDate.hour &&
          d.minute == selectedDate.minute,
    );

    if (!isAlreadyExcluded) {
      currentExclusions.add(selectedDate);

      final updatedMaster = master.copyWith(exceptionDates: currentExclusions);
      await _evtBox.put(master.key, updatedMaster);

      appLogger.i(
        'Occurrence at $selectedDate added to exceptions for Master ID: ${master.id}',
      );
    }
  }

  PetAppointment? getEventByKey(dynamic key) {
    final actualKey = key is String ? int.tryParse(key) : key;
    return _evtBox.get(actualKey);
  }

  Future<void> deleteEventsForPetId(dynamic id) async {
    final keysToDelete = _evtBox.keys.where((k) {
      final event = _evtBox.get(k);
      appLogger.i('Checking Event: ${event?.title}, PetID: ${event?.petId}');
      return event?.petId.toString() == id.toString();
    }).toList();

    if (keysToDelete.isNotEmpty) {
      await _evtBox.deleteAll(keysToDelete);
    }
  }
}
