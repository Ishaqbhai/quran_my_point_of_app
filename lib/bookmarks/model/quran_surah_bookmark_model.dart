// // ignore_for_file: public_member_api_docs, sort_constructors_first
// class QuranSurahBookmarkModel {
//   int surahNumber;
//   int ayahNumber;
//   bool translation;
//   int? id;
//   String surahName;
//   QuranSurahBookmarkModel({
//     required this.surahNumber,
//     required this.ayahNumber,
//     required this.translation,
//     required this.surahName,
//     this.id,
//   });
// }
import 'package:hive/hive.dart';

part 'quran_surah_bookmark_model.g.dart'; // Auto-generated file

@HiveType(typeId: 0) // Unique typeId for each model
class QuranSurahBookmarkModel extends HiveObject {
  @HiveField(0)
  int surahNumber;

  @HiveField(1)
  int ayahNumber;

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
