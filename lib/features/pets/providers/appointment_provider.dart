import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:workspace/data/models/hive/event.dart';

class AppointmentProvider extends ChangeNotifier {
  final Box<Event> _evtBox = Hive.box<Event>('events');

  List<Event> get events => _evtBox.values.toList();
  int get count => _evtBox.length;

  AppointmentProvider() {
    _evtBox.listenable().addListener(notifyListeners);
  }

  @override
  void dispose() {
    _evtBox.listenable().removeListener(notifyListeners);
    super.dispose();
  }

  void addEvent(Event event) {
    _evtBox.add(event);
  }

  void updateEvent(Event originalEvent, Event updatedEvent) {
    _evtBox.put(originalEvent.key, updatedEvent);
  }

  void deleteEvent(Event event) {
    event.delete();
  }

  Event? getEventByKey(dynamic key) {
    final actualKey = key is String ? int.tryParse(key) : key;
    return _evtBox.get(actualKey);
  }
}
