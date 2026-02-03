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
      id: fields[0] as dynamic,
      petId: fields[1] as dynamic,
      title: fields[2] as String?,
      from: fields[3] as DateTime?,
      to: fields[4] as DateTime?,
      description: fields[5] as String?,
      background: fields[6] as Color?,
      isAllDay: fields[7] as bool?,
      recurrenceRule: fields[8] as String?,
      recurrenceId: fields[9] as dynamic,
      exceptionDates: (fields[10] as List?)?.cast<DateTime>(),
      appointmentType: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PetAppointment obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.petId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.from)
      ..writeByte(4)
      ..write(obj.to)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.background)
      ..writeByte(7)
      ..write(obj.isAllDay)
      ..writeByte(8)
      ..write(obj.recurrenceRule)
      ..writeByte(9)
      ..write(obj.recurrenceId)
      ..writeByte(10)
      ..write(obj.exceptionDates)
      ..writeByte(11)
      ..write(obj.appointmentType);
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
