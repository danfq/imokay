// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sound_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SoundDataAdapter extends TypeAdapter<SoundData> {
  @override
  final int typeId = 1;

  @override
  SoundData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SoundData(
      name: fields[0] as String,
      isFavorite: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SoundData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SoundDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
