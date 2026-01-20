// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:hive_ce/hive_ce.dart';

part 'settings.g.dart';

@HiveType(typeId: 1)
class Settings {
  @HiveField(0)
  final String theme;

  Settings({
    required this.theme,
  });

  @override
  String toString() => 'Settings(theme: $theme)';

  Settings copyWith({
    String? theme,
  }) {
    return Settings(
      theme: theme ?? this.theme,
    );
  }

  @override
  bool operator ==(covariant Settings other) {
    if (identical(this, other)) return true;

    return other.theme == theme;
  }

  @override
  int get hashCode => theme.hashCode;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'theme': theme,
    };
  }

  factory Settings.fromMap(Map<String, dynamic> map) {
    return Settings(
      theme: map['theme'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Settings.fromJson(String source) =>
      Settings.fromMap(json.decode(source) as Map<String, dynamic>);
}
