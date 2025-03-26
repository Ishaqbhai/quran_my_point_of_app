// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hadith_bookmark_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HadithBookmarkModelAdapter extends TypeAdapter<HadithBookmarkModel> {
  @override
  final int typeId = 1;

  @override
  HadithBookmarkModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HadithBookmarkModel(
      collectionName: fields[0] as String,
      bookNo: fields[1] as int,
      hadithaNo: fields[2] as int,
      totalNoOfHadith: fields[3] as int,
      translation: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, HadithBookmarkModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.collectionName)
      ..writeByte(1)
      ..write(obj.bookNo)
      ..writeByte(2)
      ..write(obj.hadithaNo)
      ..writeByte(3)
      ..write(obj.totalNoOfHadith)
      ..writeByte(4)
      ..write(obj.translation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HadithBookmarkModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
