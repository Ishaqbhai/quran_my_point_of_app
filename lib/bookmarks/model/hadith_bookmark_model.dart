
import 'package:hive/hive.dart';

part 'hadith_bookmark_model.g.dart';

@HiveType(typeId: 1) // Different typeId from the other model
class HadithBookmarkModel extends HiveObject {
  @HiveField(0)
  String collectionName;

  @HiveField(1)
  int bookNo;

  @HiveField(2)
  int hadithaNo;

  @HiveField(3)
  int totalNoOfHadith;

  @HiveField(4)
  bool translation;

  HadithBookmarkModel({
    required this.collectionName,
    required this.bookNo,
    required this.hadithaNo,
    required this.totalNoOfHadith,
    required this.translation,
  });
}
