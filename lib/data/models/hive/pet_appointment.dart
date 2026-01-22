import 'dart:convert';
import 'dart:ui';

import 'package:hive_ce/hive_ce.dart';

part 'pet_appointment.g.dart';

@HiveType(typeId: 2)
class PetAppointment extends HiveObject {
  @HiveField(0)
  String? title;

  @HiveField(1)
  String petId;

  @HiveField(2)
  DateTime? from;

  @HiveField(3)
  DateTime? to;

  @HiveField(4)
  Color? background;

  @HiveField(5)
  bool? isAllDay;

  @HiveField(6)
  String? recurrenceRule;

  @HiveField(7)
  String? description;

  PetAppointment({
    required this.title,
    required this.petId,
    this.from,
    this.to,
    this.background,
    this.isAllDay,
    this.recurrenceRule,
    this.description,
  });

  PetAppointment.empty({
    this.title,
    required this.petId,
    this.from,
    this.to,
    this.background,
    this.isAllDay = false,
    this.recurrenceRule,
    this.description,
  });

  @override
  String toString() {
    return 'PetAppointment(title: $title, petId: $petId, from: $from, to: $to, background: $background, isAllDay: $isAllDay, recurrenceRule: $recurrenceRule, description: $description)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'petId': petId,
      'from': from?.millisecondsSinceEpoch,
      'to': to?.millisecondsSinceEpoch,
      'background': background?.value,
      'isAllDay': isAllDay,
      'recurrenceRule': recurrenceRule,
      'description': description,
    };
  }

  factory PetAppointment.fromMap(Map<String, dynamic> map) {
    return PetAppointment(
      title: map['title'] as String,
      petId: map['petId'] as String,
      from: map['from'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['from'] as int)
          : null,
      to: map['to'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['to'] as int)
          : null,
      background: map['background'] != null
          ? Color(map['background'] as int)
          : null,
      isAllDay: map['isAllDay'] != null ? map['isAllDay'] as bool : null,
      recurrenceRule: map['recurrenceRule'] != null
          ? map['recurrenceRule'] as String
          : null,
      description: map['description'] != null
          ? map['description'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PetAppointment.fromJson(String source) =>
      PetAppointment.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant PetAppointment other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.petId == petId &&
        other.from == from &&
        other.to == to &&
        other.background == background &&
        other.isAllDay == isAllDay &&
        other.recurrenceRule == recurrenceRule &&
        other.description == description;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        petId.hashCode ^
        from.hashCode ^
        to.hashCode ^
        background.hashCode ^
        isAllDay.hashCode ^
        recurrenceRule.hashCode ^
        description.hashCode;
  }

  PetAppointment copyWith({
    String? title,
    String? petId,
    DateTime? from,
    DateTime? to,
    Color? background,
    bool? isAllDay,
    String? recurrenceRule,
    String? description,
  }) {
    return PetAppointment(
      title: title ?? this.title,
      petId: petId ?? this.petId,
      from: from ?? this.from,
      to: to ?? this.to,
      background: background ?? this.background,
      isAllDay: isAllDay ?? this.isAllDay,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      description: description ?? this.description,
    );
  }
}
