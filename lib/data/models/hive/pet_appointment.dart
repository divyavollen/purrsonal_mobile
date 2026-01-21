import 'dart:convert';
import 'dart:ui';

import 'package:hive_ce/hive_ce.dart';

part 'pet_appointment.g.dart';

@HiveType(typeId: 2)
class PetAppointment extends HiveObject {
  @HiveField(0)
  String eventName;

  @HiveField(1)
  DateTime? from;

  @HiveField(2)
  DateTime? to;

  @HiveField(3)
  Color? background;

  @HiveField(4)
  bool isAllDay;

  @HiveField(5)
  String? description;

  @HiveField(6)
  String recurrenceRule;

  PetAppointment({
    required this.eventName,
    required this.from,
    required this.to,
    required this.background,
    required this.isAllDay,
    required this.description,
    required this.recurrenceRule,
  });

  PetAppointment.empty({
    this.eventName = '',
    this.from,
    this.to,
    this.background,
    this.isAllDay = false,
    this.description,
    this.recurrenceRule = '',
  });

  PetAppointment copyWith({
    String? eventName,
    DateTime? from,
    DateTime? to,
    Color? background,
    bool? isAllDay,
    String? description,
    String? recurrenceRule,
  }) {
    return PetAppointment(
      eventName: eventName ?? this.eventName,
      from: from ?? this.from,
      to: to ?? this.to,
      background: background ?? this.background,
      isAllDay: isAllDay ?? this.isAllDay,
      description: description ?? this.description,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
    );
  }

  @override
  String toString() {
    return 'PetAppointment(eventName: $eventName, from: $from, to: $to, background: $background, isAllDay: $isAllDay, description: $description, recurrenceRule: $recurrenceRule)';
  }

  @override
  bool operator ==(covariant PetAppointment other) {
    if (identical(this, other)) return true;

    return other.eventName == eventName &&
        other.from == from &&
        other.to == to &&
        other.background == background &&
        other.isAllDay == isAllDay &&
        other.description == description &&
        other.recurrenceRule == recurrenceRule;
  }

  @override
  int get hashCode {
    return eventName.hashCode ^
        from.hashCode ^
        to.hashCode ^
        background.hashCode ^
        isAllDay.hashCode ^
        description.hashCode ^
        recurrenceRule.hashCode;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'eventName': eventName,
      'from': from?.millisecondsSinceEpoch,
      'to': to?.millisecondsSinceEpoch,
      'background': background?.toARGB32(),
      'isAllDay': isAllDay,
      'description': description,
      'recurrenceRule': recurrenceRule,
    };
  }

  factory PetAppointment.fromMap(Map<String, dynamic> map) {
    return PetAppointment(
      eventName: map['eventName'] as String,
      from: map['from'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['from'] as int)
          : null,
      to: map['to'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['to'] as int)
          : null,
      background: map['background'] != null
          ? Color(map['background'] as int)
          : null,
      isAllDay: map['isAllDay'] as bool,
      description: map['description'] != null
          ? map['description'] as String
          : null,
      recurrenceRule: map['recurrenceRule'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PetAppointment.fromJson(String source) =>
      PetAppointment.fromMap(json.decode(source) as Map<String, dynamic>);
}
