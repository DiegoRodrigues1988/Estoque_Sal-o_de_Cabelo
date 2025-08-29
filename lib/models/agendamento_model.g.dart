// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agendamento_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AgendamentoAdapter extends TypeAdapter<Agendamento> {
  @override
  final int typeId = 3;

  @override
  Agendamento read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Agendamento(
      id: fields[0] as String,
      clienteId: fields[1] as String,
      clienteNome: fields[2] as String,
      data: fields[3] as DateTime,
      status: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Agendamento obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.clienteId)
      ..writeByte(2)
      ..write(obj.clienteNome)
      ..writeByte(3)
      ..write(obj.data)
      ..writeByte(4)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AgendamentoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
