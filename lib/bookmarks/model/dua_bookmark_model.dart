import 'package:hive/hive.dart';

part 'dua_bookmark_model.g.dart'; // Will be generated

@HiveType(typeId: 3) // Give a new unique typeId
class DuaBookmarkModel extends HiveObject {
  @HiveField(0)
  int duaIndex;

  @HiveField(1)
  String category;

   @HiveField(2)
  String duaTitle;

  DuaBookmarkModel({required this.duaIndex, required this.category, required this.duaTitle});
}
