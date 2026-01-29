import 'package:flutter/material.dart';
import 'package:hive_ce/hive_ce.dart';

part 'pet_appointment.g.dart';

const _undefined = Object();

@HiveType(typeId: 2)
class PetAppointment extends HiveObject {
  @HiveField(0)
  dynamic id;

  @HiveField(1)
  dynamic petId;

  @HiveField(2)
  String? title;

  @HiveField(3)
  DateTime? from;

  @HiveField(4)
  DateTime? to;

  @HiveField(5)
  String? description;

  @HiveField(6)
  Color? background;

  @HiveField(7)
  bool? isAllDay;

  @HiveField(8)
  String? recurrenceRule;

  @HiveField(9)
  dynamic recurrenceId;

  @HiveField(10)
  List<DateTime>? exceptionDates;

  PetAppointment({
    required this.id,
    required this.petId,
    this.title,
    this.from,
    this.to,
    this.description,
    this.background,
    this.isAllDay,
    this.recurrenceRule,
    this.recurrenceId,
    this.exceptionDates,
  });

  PetAppointment.empty({
    this.id,
    this.title,
    this.isAllDay = false,
    required this.petId,
    this.background = const Color.fromARGB(255, 240, 177, 177),
    this.from,
    this.to,
    this.description,
    this.recurrenceRule,
    this.recurrenceId,
    this.exceptionDates = const [],
  });

  PetAppointment copyWith({
    String? title,
    dynamic petId,
    DateTime? from,
    DateTime? to,
    Color? background,
    bool? isAllDay,
    Object? recurrenceRule = _undefined,
    String? description,
    dynamic id,
    dynamic recurrenceId = _undefined,
    List<DateTime>? exceptionDates,
  }) {
    return PetAppointment(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      title: title ?? this.title,
      from: from ?? this.from,
      to: to ?? this.to,
      description: description ?? this.description,
      background: background ?? this.background,
      isAllDay: isAllDay ?? this.isAllDay,
      recurrenceRule: recurrenceRule == _undefined
          ? this.recurrenceRule
          : recurrenceRule as String?,
      recurrenceId: recurrenceId == _undefined
          ? this.recurrenceId
          : recurrenceId,
      exceptionDates: exceptionDates ?? this.exceptionDates,
    );
  }

  @override
  String toString() {
    return 'PetAppointment(id: $id, petId: $petId, title: $title, from: $from, to: $to, description: $description, background: $background, isAllDay: $isAllDay, recurrenceRule: $recurrenceRule, recurrenceId: $recurrenceId, exceptionDates: $exceptionDates)';
  }
}
