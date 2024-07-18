// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayerAdapter extends TypeAdapter<Player> {
  @override
  final int typeId = 0;

  @override
  Player read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Player(
      id: fields[0] as Int,
      name: fields[1] as String,
      cpf: fields[2] as String,
      sexo: fields[3] as String,
      peso: fields[4] as Float,
      altura: fields[5] as Float,
      sport: fields[6] as String,
      posicao: fields[7] as String,
      observacao: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Player obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.cpf)
      ..writeByte(3)
      ..write(obj.sexo)
      ..writeByte(4)
      ..write(obj.peso)
      ..writeByte(5)
      ..write(obj.altura)
      ..writeByte(6)
      ..write(obj.sport)
      ..writeByte(7)
      ..write(obj.posicao)
      ..writeByte(8)
      ..write(obj.observacao);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
