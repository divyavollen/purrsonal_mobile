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
      title: fields[0] as String?,
      petId: fields[1] as String,
      from: fields[2] as DateTime?,
      to: fields[3] as DateTime?,
      background: fields[4] as Color?,
      isAllDay: fields[5] as bool?,
      recurrenceRule: fields[6] as String?,
      description: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PetAppointment obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.petId)
      ..writeByte(2)
      ..write(obj.from)
      ..writeByte(3)
      ..write(obj.to)
      ..writeByte(4)
      ..write(obj.background)
      ..writeByte(5)
      ..write(obj.isAllDay)
      ..writeByte(6)
      ..write(obj.recurrenceRule)
      ..writeByte(7)
      ..write(obj.description);
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
