// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venda_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VendaAdapter extends TypeAdapter<Venda> {
  @override
  final int typeId = 2;

  @override
  Venda read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Venda(
      id: fields[0] as String,
      produtoId: fields[1] as String,
      produtoNome: fields[2] as String,
      quantidade: fields[3] as int,
      totalCusto: fields[4] as double,
      totalVenda: fields[5] as double,
      dataVenda: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Venda obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.produtoId)
      ..writeByte(2)
      ..write(obj.produtoNome)
      ..writeByte(3)
      ..write(obj.quantidade)
      ..writeByte(4)
      ..write(obj.totalCusto)
      ..writeByte(5)
      ..write(obj.totalVenda)
      ..writeByte(6)
      ..write(obj.dataVenda);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VendaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
