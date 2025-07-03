import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:quran_hadith_app/bookmarks/model/dua_bookmark_model.dart';
import 'package:quran_hadith_app/bookmarks/model/hadith_bookmark_model.dart';
import 'package:quran_hadith_app/bookmarks/model/juz_bookmark_model.dart';
import 'package:quran_hadith_app/bookmarks/model/quran_surah_bookmark_model.dart';

class BookmarkController extends GetxController {
  late Box<QuranSurahBookmarkModel> quranBookmarkBox;
  late Box<HadithBookmarkModel> hadithBookmarkBox;
  late Box<JuzBookmarkModel> juzBookmarkBox;
  late Box<DuaBookmarkModel> duaBookmarkBox;
  RxList<JuzBookmarkModel> juzBookmarkList = <JuzBookmarkModel>[].obs;
  RxList<QuranSurahBookmarkModel> surahBookmarkList =
      <QuranSurahBookmarkModel>[].obs;
  RxList<HadithBookmarkModel> hadithBookmarkList = <HadithBookmarkModel>[].obs;
  RxList<DuaBookmarkModel> duaBookmarkList = <DuaBookmarkModel>[].obs;
  RxBool isJuzMarked = false.obs;
  RxBool isSurahMarked = false.obs;

  @override
  void onInit() {
    super.onInit();
    quranBookmarkBox = Hive.box<QuranSurahBookmarkModel>('QuranBookmarks');
    hadithBookmarkBox = Hive.box<HadithBookmarkModel>('HadithBookmarks');
    juzBookmarkBox = Hive.box<JuzBookmarkModel>('JuzBookmarks');
    duaBookmarkBox = Hive.box<DuaBookmarkModel>('DuaBookmarks');
    getJuzBookmark();
    getSurahBookmark();
    getHadithBookmark();
    getDuaBookmark();
  }

  void toggleSurahBookmark({
    required int surahNumber,
    required int? ayahNumber,
    required int? pageNo,
    required bool translation,
    required String surahName,
  }) async {
    final existingKey = quranBookmarkBox.keys.firstWhere((key) {
      final bookmark = quranBookmarkBox.get(key);
      return bookmark?.surahNumber == surahNumber &&
          bookmark?.ayahNumber == ayahNumber &&
          bookmark?.translation == translation &&
          bookmark?.pageNo == pageNo;
    }, orElse: () => null);

    if (existingKey != null) {
      await quranBookmarkBox.delete(existingKey);
      Get.snackbar("Bookmark", "Surah bookmark removed");
    } else {
      await quranBookmarkBox.add(
        QuranSurahBookmarkModel(
          surahNumber: surahNumber,
          ayahNumber: ayahNumber,
          translation: translation,
          surahName: surahName,
          pageNo: pageNo,
        ),
      );
      Get.snackbar("Bookmark", "Surah bookmark added");
    }
    getSurahBookmark();
    checkSurahBookmarked(
      ayahNumber: ayahNumber,
      pageNo: pageNo,
      surahNumber: surahNumber,
      translation: translation,
    );

    update();
  }

  void checkSurahBookmarked({
    required int surahNumber,
    required int? ayahNumber,
    required bool translation,
    required int? pageNo,
  }) {
    isSurahMarked.value = quranBookmarkBox.values.any(
      (bookmark) =>
          bookmark.surahNumber == surahNumber &&
          bookmark.ayahNumber == ayahNumber &&
          bookmark.translation == translation &&
          bookmark.pageNo == pageNo,
    );
  }

  bool isSurahBookmarked({
    required int surahNumber,
    required int? ayahNumber,
    required bool translation,
  }) {
    return quranBookmarkBox.values.any(
      (bookmark) =>
          bookmark.surahNumber == surahNumber &&
          bookmark.ayahNumber == ayahNumber &&
          bookmark.translation == translation,
    );
  }

  void getSurahBookmark() {
    surahBookmarkList.clear();
    surahBookmarkList.addAll(quranBookmarkBox.values.toList());
  }

  void removeSurahBookmark({required QuranSurahBookmarkModel bookmark}) async {
    int index = quranBookmarkBox.values.toList().indexOf(bookmark);
    if (index != -1) {
      await quranBookmarkBox.deleteAt(index);
    }
    getSurahBookmark();
  }

  void toggleHadithBookmark({
    required int bookNumber,
    required int hadithNumber,
    required bool translation,
    required String collectionName,
    required int noOfHadith,
  }) async {
    final existingKey = hadithBookmarkBox.keys.firstWhere((key) {
      final bookmark = hadithBookmarkBox.get(key);
      return bookmark?.bookNo == bookNumber &&
          bookmark?.hadithaNo == hadithNumber &&
          bookmark?.translation == translation &&
          bookmark?.collectionName == collectionName;
    }, orElse: () => null);

    if (existingKey != null) {
      await hadithBookmarkBox.delete(existingKey);
      Get.snackbar("Bookmark", "Hadith bookmark removed");
    } else {
      await hadithBookmarkBox.add(
        HadithBookmarkModel(
          bookNo: bookNumber,
          hadithaNo: hadithNumber,
          translation: translation,
          collectionName: collectionName,
          totalNoOfHadith: noOfHadith,
        ),
      );
      Get.snackbar("Bookmark", "Hadith bookmark added");
    }

    getHadithBookmark(); // Refreshes the local list
    update(); // Notifies UI via GetBuilder
  }

  bool isHadithBookmarked({
    required int bookNumber,
    required int hadithNumber,
    required bool translation,
    required String collectionName,
  }) {
    return hadithBookmarkBox.values.any(
      (bookmark) =>
          bookmark.bookNo == bookNumber &&
          bookmark.hadithaNo == hadithNumber &&
          bookmark.translation == translation &&
          bookmark.collectionName == collectionName,
    );
  }

  void getHadithBookmark() {
    hadithBookmarkList.clear();
    hadithBookmarkList.addAll(hadithBookmarkBox.values.toList());
  }

  void removeHadithBookmark(HadithBookmarkModel bookmark) async {
    int index = hadithBookmarkBox.values.toList().indexOf(bookmark);
    if (index != -1) {
      await hadithBookmarkBox.deleteAt(index);
    }
    getHadithBookmark();
  }

  bool isJuzBookmarked({
    required int juzNumber,
    required int endAyahNumber,
    required int surahNumber,
  }) {
    return juzBookmarkBox.values.any(
      (bookmark) =>
          bookmark.juzNumber == juzNumber &&
          bookmark.endAyahNumber == endAyahNumber &&
          bookmark.surahNumber == surahNumber,
    );
  }

  void checkJuzBookMarked({
    required int juzNumber,
    required int? pageNumber,
    required int endAyahNumber,
  }) {
    isJuzMarked.value = juzBookmarkList.any(
      (bookmark) =>
          bookmark.juzNumber == juzNumber &&
          bookmark.pageNumber == pageNumber &&
          bookmark.endAyahNumber == endAyahNumber,
    );
  }

  void toggleJuzBookmark({
    required int pageNumber,
    required int juzNumber,
    required int surahNo,
    required int endAyahNumber,
    required bool translation,
  }) async {
    final existingKey = juzBookmarkBox.keys.firstWhere((key) {
      final bookmark = juzBookmarkBox.get(key);
      return bookmark?.juzNumber == juzNumber &&
          bookmark?.surahNumber == surahNo &&
          bookmark?.endAyahNumber == endAyahNumber;
    }, orElse: () => null);

    if (existingKey != null) {
      await juzBookmarkBox.delete(existingKey);
      Get.snackbar("Bookmark", "Bookmark removed");
    } else {
      await juzBookmarkBox.add(
        JuzBookmarkModel(
          pageNumber: pageNumber,
          juzNumber: juzNumber,
          surahNumber: surahNo,
          endAyahNumber: endAyahNumber,
          translation: translation,
        ),
      );
      Get.snackbar("Bookmark", "Bookmark added");
    }

    getJuzBookmark(); // Update the list
    update(); // Rebuild GetBuilder widgets
  }

  RxSet<String> juzBookmarkKeySet = <String>{}.obs;

  void getJuzBookmark() {
    juzBookmarkList.clear();
    juzBookmarkList.addAll(juzBookmarkBox.values.toList());

    // Update reactive key set
    juzBookmarkKeySet.clear();
    for (var b in juzBookmarkList) {
      juzBookmarkKeySet.add(
        "${b.juzNumber}_${b.pageNumber}_${b.endAyahNumber}",
      );
    }
  }

  void removeJuzBookmark(JuzBookmarkModel bookmark) async {
    int index = juzBookmarkBox.values.toList().indexOf(bookmark);
    if (index != -1) {
      await juzBookmarkBox.deleteAt(index);
    }
    getJuzBookmark();
  }

  void toggleDuaBookmark({
    required int duaIndex,
    required String duaTitle,
    required String category,
  }) async {
    final existingKey = duaBookmarkBox.keys.firstWhere((key) {
      final bookmark = duaBookmarkBox.get(key);
      return bookmark?.duaIndex == duaIndex && bookmark?.category == category;
    }, orElse: () => null);

    if (existingKey != null) {
      await duaBookmarkBox.delete(existingKey);
      Get.snackbar("Bookmark", "Dua bookmark removed");
    } else {
      await duaBookmarkBox.add(
        DuaBookmarkModel(
          category: category,
          duaIndex: duaIndex,
          duaTitle: duaTitle,
        ),
      );
      Get.snackbar("Bookmark", "Dua bookmark added");
    }

    getDuaBookmark(); // Refresh the list
    update(); // Notify listeners if using GetBuilder
  }

  bool isDuaBookmarked({required int duaIndex, required String category}) {
    return duaBookmarkBox.values.any(
      (bookmark) =>
          bookmark.duaIndex == duaIndex && bookmark.category == category,
    );
  }

  void getDuaBookmark() {
    duaBookmarkList.clear();
    duaBookmarkList.addAll(duaBookmarkBox.values.toList());
  }

  void removeDuaBookmark(DuaBookmarkModel bookmark) async {
    int index = duaBookmarkBox.values.toList().indexOf(bookmark);
    if (index != -1) {
      await duaBookmarkBox.deleteAt(index);
    }
    getDuaBookmark();
  }
}
