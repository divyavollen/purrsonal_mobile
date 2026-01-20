// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:ui';

import 'package:hive_ce/hive_ce.dart';

part 'event.g.dart';

@HiveType(typeId: 2)
class Event extends HiveObject {
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

  Event({
    required this.eventName,
    required this.from,
    required this.to,
    required this.background,
    required this.isAllDay,
    required this.description,
  });

  Event.empty({
    this.eventName = '',
    this.from,
    this.to,
    this.background,
    this.isAllDay = false,
    this.description,
  });

  Event copyWith({
    String? eventName,
    DateTime? from,
    DateTime? to,
    Color? background,
    bool? isAllDay,
    String? startTimeZone,
    String? endTimeZone,
    String? description,
  }) {
    return Event(
      eventName: eventName ?? this.eventName,
      from: from ?? this.from,
      to: to ?? this.to,
      background: background ?? this.background,
      isAllDay: isAllDay ?? this.isAllDay,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'eventName': eventName,
      'from': from!.millisecondsSinceEpoch,
      'to': to!.millisecondsSinceEpoch,
      'background': background.toString(),
      'isAllDay': isAllDay,
      'description': description,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      eventName: map['eventName'] as String,
      from: DateTime.fromMillisecondsSinceEpoch(map['from'] as int),
      to: DateTime.fromMillisecondsSinceEpoch(map['to'] as int),
      background: Color(map['background'] as int),
      isAllDay: map['isAllDay'] as bool,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Event.fromJson(String source) =>
      Event.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Event(eventName: $eventName, from: $from, to: $to, background: $background, isAllDay: $isAllDay,  description: $description)';
  }

  @override
  bool operator ==(covariant Event other) {
    if (identical(this, other)) return true;

    return other.eventName == eventName &&
        other.from == from &&
        other.to == to &&
        other.background == background &&
        other.isAllDay == isAllDay &&
        other.description == description;
  }

  @override
  int get hashCode {
    return eventName.hashCode ^
        from.hashCode ^
        to.hashCode ^
        background.hashCode ^
        isAllDay.hashCode ^
        description.hashCode;
  }
}
