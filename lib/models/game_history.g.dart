// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameHistoryAdapter extends TypeAdapter<GameHistory> {
  @override
  final int typeId = 2;

  @override
  GameHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameHistory(
      id: fields[0] as int,
      title: fields[1] as String,
      timestamp: fields[2] as DateTime,
      imposterId: fields[3] as int,
      imposterName: fields[4] as String,
      imposterPhone: fields[5] as String,
      crewmateQuestion: fields[6] as String,
      imposterQuestion: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GameHistory obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.timestamp)
      ..writeByte(3)
      ..write(obj.imposterId)
      ..writeByte(4)
      ..write(obj.imposterName)
      ..writeByte(5)
      ..write(obj.imposterPhone)
      ..writeByte(6)
      ..write(obj.crewmateQuestion)
      ..writeByte(7)
      ..write(obj.imposterQuestion);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
