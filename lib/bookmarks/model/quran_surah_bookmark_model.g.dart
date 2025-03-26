// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quran_surah_bookmark_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuranSurahBookmarkModelAdapter
    extends TypeAdapter<QuranSurahBookmarkModel> {
  @override
  final int typeId = 0;

  @override
  QuranSurahBookmarkModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuranSurahBookmarkModel(
      surahNumber: fields[0] as int,
      ayahNumber: fields[1] as int,
      translation: fields[2] as bool,
      surahName: fields[3] as String,
      pageNo: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, QuranSurahBookmarkModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.surahNumber)
      ..writeByte(1)
      ..write(obj.ayahNumber)
      ..writeByte(2)
      ..write(obj.translation)
      ..writeByte(3)
      ..write(obj.surahName)
      ..writeByte(4)
      ..write(obj.pageNo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuranSurahBookmarkModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
