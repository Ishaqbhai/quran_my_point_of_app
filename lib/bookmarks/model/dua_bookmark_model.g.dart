// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dua_bookmark_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DuaBookmarkModelAdapter extends TypeAdapter<DuaBookmarkModel> {
  @override
  final int typeId = 3;

  @override
  DuaBookmarkModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DuaBookmarkModel(
      duaIndex: fields[0] as int,
      category: fields[1] as String,
      duaTitle: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DuaBookmarkModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.duaIndex)
      ..writeByte(1)
      ..write(obj.category)
      ..writeByte(2)
      ..write(obj.duaTitle);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DuaBookmarkModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
