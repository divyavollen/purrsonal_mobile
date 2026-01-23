import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:workspace/data/models/hive/pet_appointment.dart';

class AppointmentDatasource extends CalendarDataSource {
  AppointmentDatasource(List<PetAppointment> source) {
    appointments = source;
  }

  @override
  Object? convertAppointmentToObject(
    Object? customData,
    Appointment appointment,
  ) {
    return customData;
  }

  @override
  DateTime getStartTime(int index) =>
      appointments![index].from ?? DateTime.now();

  @override
  DateTime getEndTime(int index) =>
      appointments![index].to ?? DateTime.now().add(Duration(hours: 1));

  @override
  String getSubject(int index) => appointments![index].title ?? '';

  @override
  Color getColor(int index) => appointments![index].background ?? Colors.white;

  @override
  bool isAllDay(int index) => appointments![index].isAllDay ?? false;

  @override
  String? getNotes(int index) => appointments![index].description;

  @override
  String? getRecurrenceRule(int index) => appointments![index].recurrenceRule;

  String getPetId(int index) => appointments![index].petId;
}
