
import 'package:hive/hive.dart';

part 'quran_surah_bookmark_model.g.dart'; // Auto-generated file

@HiveType(typeId: 4) // Unique typeId for each model
class QuranSurahBookmarkModel extends HiveObject {
  @HiveField(0)
  int surahNumber;

  @HiveField(1)
  int? ayahNumber;

  @HiveField(2)
  bool translation;

  @HiveField(3)
  String surahName;

  @HiveField(4)
  int? pageNo;

  QuranSurahBookmarkModel({
    required this.surahNumber,
    required this.ayahNumber,
    required this.translation,
    required this.surahName,
    this.pageNo,
  });
}
