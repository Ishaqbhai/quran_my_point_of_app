
import 'package:hive/hive.dart';

part 'juz_bookmark_model.g.dart'; // This will be generated

@HiveType(typeId: 2) // Ensure a unique typeId
class JuzBookmarkModel extends HiveObject {
  @HiveField(0)
  int? pageNumber;

  @HiveField(1)
  int juzNumber;

  @HiveField(2)
  int? endAyahNumber;

  @HiveField(3)
  bool translation;

  @HiveField(4)
  int surahNumber;

  @HiveField(5)
  int? surahStartAyahNumber;

  JuzBookmarkModel({
    this.pageNumber,
    required this.juzNumber,
    this.endAyahNumber,
    required this.translation,
    required this.surahNumber,
    this.surahStartAyahNumber,
  });
}
