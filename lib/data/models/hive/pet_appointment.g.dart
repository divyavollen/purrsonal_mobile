// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_appointment.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PetAppointmentAdapter extends TypeAdapter<PetAppointment> {
  @override
  final typeId = 2;

  @override
  PetAppointment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PetAppointment(
      eventName: fields[0] as String,
      from: fields[1] as DateTime?,
      to: fields[2] as DateTime?,
      background: fields[3] as Color?,
      isAllDay: fields[4] as bool,
      description: fields[5] as String?,
      recurrenceRule: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PetAppointment obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.eventName)
      ..writeByte(1)
      ..write(obj.from)
      ..writeByte(2)
      ..write(obj.to)
      ..writeByte(3)
      ..write(obj.background)
      ..writeByte(4)
      ..write(obj.isAllDay)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.recurrenceRule);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PetAppointmentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
