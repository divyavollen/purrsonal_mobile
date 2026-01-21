import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:workspace/data/models/hive/pet_appointment.dart';

class AppointmentProvider extends ChangeNotifier {
  final Box<PetAppointment> _evtBox = Hive.box<PetAppointment>('events');

  List<PetAppointment> get events => _evtBox.values.toList();
  int get count => _evtBox.length;

  AppointmentProvider() {
    _evtBox.listenable().addListener(notifyListeners);
  }

  @override
  void dispose() {
    _evtBox.listenable().removeListener(notifyListeners);
    super.dispose();
  }

  void addEvent(PetAppointment event) {
    _evtBox.add(event);
  }

  void updateEvent(PetAppointment originalEvent, PetAppointment updatedEvent) {
    _evtBox.put(originalEvent.key, updatedEvent);
  }

  void deleteEvent(PetAppointment event) {
    event.delete();
  }

  PetAppointment? getEventByKey(dynamic key) {
    final actualKey = key is String ? int.tryParse(key) : key;
    return _evtBox.get(actualKey);
  }
}
