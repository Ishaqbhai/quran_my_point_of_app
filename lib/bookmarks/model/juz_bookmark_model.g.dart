// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'juz_bookmark_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JuzBookmarkModelAdapter extends TypeAdapter<JuzBookmarkModel> {
  @override
  final int typeId = 2;

  @override
  JuzBookmarkModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return JuzBookmarkModel(
      pageNumber: fields[0] as int?,
      juzNumber: fields[1] as int,
      endAyahNumber: fields[2] as int?,
      translation: fields[3] as bool,
      surahNumber: fields[4] as int,
      surahStartAyahNumber: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, JuzBookmarkModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.pageNumber)
      ..writeByte(1)
      ..write(obj.juzNumber)
      ..writeByte(2)
      ..write(obj.endAyahNumber)
      ..writeByte(3)
      ..write(obj.translation)
      ..writeByte(4)
      ..write(obj.surahNumber)
      ..writeByte(5)
      ..write(obj.surahStartAyahNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JuzBookmarkModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
