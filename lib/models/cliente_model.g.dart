// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cliente_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClienteAdapter extends TypeAdapter<Cliente> {
  @override
  final int typeId = 0;

  @override
  Cliente read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Cliente(
      id: fields[0] as String,
      nome: fields[1] as String,
      telefone: fields[2] as String,
      ultimaVisita: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Cliente obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.nome)
      ..writeByte(2)
      ..write(obj.telefone)
      ..writeByte(3)
      ..write(obj.ultimaVisita);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClienteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
