import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:flutter_quran/flutter_quran.dart';
import 'package:quran_hadith_app/bookmarks/model/hadith_bookmark_model.dart';
import 'package:quran_hadith_app/bookmarks/model/juz_bookmark_model.dart';
import 'package:quran_hadith_app/bookmarks/model/quran_surah_bookmark_model.dart';

class BookmarkController extends GetxController {
  late Box<QuranSurahBookmarkModel> quranBookmarkBox;
  late Box<HadithBookmarkModel> hadithBookmarkBox;
  late Box<JuzBookmarkModel> juzBookmarkBox;
  RxList<JuzBookmarkModel> juzBookmarkList = <JuzBookmarkModel>[].obs;
  RxList<QuranSurahBookmarkModel> surahBookmarkList =
      <QuranSurahBookmarkModel>[].obs;
  RxList<HadithBookmarkModel> hadithBookmarkList = <HadithBookmarkModel>[].obs;
  RxList<Bookmark> usedBookmarks = <Bookmark>[].obs;

  @override
  void onInit() {
    super.onInit();
    quranBookmarkBox = Hive.box<QuranSurahBookmarkModel>('QuranBookmarks');
    hadithBookmarkBox = Hive.box<HadithBookmarkModel>('HadithBookmarks');
    juzBookmarkBox = Hive.box<JuzBookmarkModel>('JuzBookmarks');
    getJuzBookmark();
    getSurahBookmark();
    getHadithBookmark();
  }

  void saveSurahBookmark({
    required int surahNumber,
    required int ayahNumber,
    required int? pageNo,
    required bool translation,
    required String surahName,
  }) async {
    QuranSurahBookmarkModel bookmark = QuranSurahBookmarkModel(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      translation: translation,
      surahName: surahName,
      pageNo: pageNo,
    );

    await quranBookmarkBox.add(bookmark);
    getSurahBookmark();
  }

  void getSurahBookmark() {
    surahBookmarkList.clear();
    surahBookmarkList.addAll(quranBookmarkBox.values.toList());
  }

  void removeSurahBookmark(QuranSurahBookmarkModel bookmark) async {
    int index = quranBookmarkBox.values.toList().indexOf(bookmark);
    if (index != -1) {
      await quranBookmarkBox.deleteAt(index);
    }
    getSurahBookmark();
  }

  void saveHadithBookmark({
    required int bookNumber,
    required int hadithNumber,
    required bool translation,
    required String collectionName,
    required int noOfHadith,
  }) async {
    HadithBookmarkModel bookmark = HadithBookmarkModel(
      bookNo: bookNumber,
      collectionName: collectionName,
      hadithaNo: hadithNumber,
      totalNoOfHadith: noOfHadith,
      translation: translation,
    );

    await hadithBookmarkBox.add(bookmark);
    getHadithBookmark();
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

  void saveJuzBookmark({
    required int pageNumber,
    required int juzNumber,
    required int endAyahNumber,
    required bool translation,
    required int surahNo,
  }) async {
    JuzBookmarkModel bookmark = JuzBookmarkModel(
      surahNumber: surahNo,
      pageNumber: pageNumber,
      juzNumber: juzNumber,
      endAyahNumber: endAyahNumber,
      translation: translation,
    );

    await juzBookmarkBox.add(bookmark);
    getJuzBookmark();
  }

  void getJuzBookmark() {
    juzBookmarkList.clear();
    juzBookmarkList.addAll(juzBookmarkBox.values.toList());
  }

  void removeJuzBookmark(JuzBookmarkModel bookmark) async {
    int index = juzBookmarkBox.values.toList().indexOf(bookmark);
    if (index != -1) {
      await juzBookmarkBox.deleteAt(index);
    }
    getJuzBookmark();
  }

  void getQuranJuzBookmark() async {
    usedBookmarks.value = FlutterQuran().getUsedBookmarks();
  }
}
