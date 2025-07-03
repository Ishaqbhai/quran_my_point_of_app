import 'package:flutter_quran/flutter_quran.dart';
import 'package:get/get.dart';
import 'package:quran/quran.dart' as quran;
import 'package:quran_flutter/models/juz_surah_verses.dart';
import 'package:quran_flutter/models/verse.dart';
import 'package:quran_flutter/quran.dart';
import 'package:quran_hadith_app/Profile/controller/profile_controller.dart';

class QuranController extends GetxController {
  RxInt quranListIndex = 0.obs;
  RxBool surahTranslation = true.obs;
  RxBool juzTranslation = true.obs;
  List<Map<String, dynamic>> surahDetails = [];
  final ProfileController profileController = Get.put(ProfileController());
  String surahJuzText = "";
  void surahJozz;
  RxInt juzSurahAyahStartNo = 0.obs;
  int pageNoJuz = 1;
  int ayahStratingNo = 1;
  int juzzNumber = 1;
  int surahStartPageNo = 1;
  int surahEndPageNo = 1;
  int surahBookmarkPageNo = 1;
  int surahVerseNo = 1;
  int ayahCountSurah = 1;
  List<String> surahVersesArabic = [];
  List<String> surahVerseTranslation = [];
  String surahName = "";

  static const List<Map<String, dynamic>> juzData = [
    {
      "juz": 1,
      "surahs": [1, 2],
    },
    {
      "juz": 2,
      "surahs": [2],
    },
    {
      "juz": 3,
      "surahs": [2, 3],
    },
    {
      "juz": 4,
      "surahs": [3, 4],
    },
    {
      "juz": 5,
      "surahs": [4],
    },
    {
      "juz": 6,
      "surahs": [4, 5],
    },
    {
      "juz": 7,
      "surahs": [5, 6],
    },
    {
      "juz": 8,
      "surahs": [6, 7],
    },
    {
      "juz": 9,
      "surahs": [7, 8],
    },
    {
      "juz": 10,
      "surahs": [8, 9],
    },
    {
      "juz": 11,
      "surahs": [9, 10, 11],
    },
    {
      "juz": 12,
      "surahs": [11, 12],
    },
    {
      "juz": 13,
      "surahs": [12, 13, 14, 15],
    },
    {
      "juz": 14,
      "surahs": [15, 16],
    },
    {
      "juz": 15,
      "surahs": [17, 18],
    },
    {
      "juz": 16,
      "surahs": [18, 19, 20],
    },
    {
      "juz": 17,
      "surahs": [21, 22],
    },
    {
      "juz": 18,
      "surahs": [23, 24, 25],
    },
    {
      "juz": 19,
      "surahs": [25, 26, 27],
    },
    {
      "juz": 20,
      "surahs": [27, 28, 29],
    },
    {
      "juz": 21,
      "surahs": [29, 30, 31, 32, 33],
    },
    {
      "juz": 22,
      "surahs": [33, 34, 35, 36],
    },
    {
      "juz": 23,
      "surahs": [36, 37, 38, 39],
    },
    {
      "juz": 24,
      "surahs": [39, 40, 41],
    },
    {
      "juz": 25,
      "surahs": [41, 42, 43, 44, 45],
    },
    {
      "juz": 26,
      "surahs": [46, 47, 48, 49, 50, 51],
    },
    {
      "juz": 27,
      "surahs": [51, 52, 53, 54, 55, 56, 57],
    },
    {
      "juz": 28,
      "surahs": [58, 59, 60, 61, 62, 63, 64, 65, 66],
    },
    {
      "juz": 29,
      "surahs": [68, 69, 70, 71, 72, 73, 74, 75, 76, 77],
    },
    {
      "juz": 30,
      "surahs": [
        78,
        79,
        80,
        81,
        82,
        83,
        84,
        85,
        86,
        87,
        88,
        89,
        90,
        91,
        92,
        93,
        94,
        95,
        96,
        97,
        98,
        99,
        100,
        101,
        102,
        103,
        104,
        105,
        106,
        107,
        108,
        109,
        110,
        111,
        112,
        113,
        114,
      ],
    },
  ];
  changequranListIndex({required int index}) {
    quranListIndex.value = index;
  }

  int getTotalVersesOfSurah({required int surahNumber}) {
    int totalVerses = Quran.getTotalVersesInSurah(surahNumber);
    return totalVerses;
  }

  List<Verse> getVersesOfSurah({required int surahNumber}) {
    List<Verse> surahVerses = Quran.getSurahVersesAsList(surahNumber);
    return surahVerses;
  }

  List<Verse> getTranslationOfSurah({required int surahNumber}) {
    List<Verse> surahVersesList2 = Quran.getSurahVersesAsList(
      surahNumber,
      language: profileController.selectedLanguage.value,
    );
    return surahVersesList2;
  }

  Future<List<Map<String, dynamic>>> getNoOfVersesInJuz({
    required int juzNumber,
    required int surahNumber,
  }) async {
    var juz = QuranController.juzData[juzNumber - 1];
    List<int> surahNumbers = juz["surahs"];

    List<JuzSurahVerses> juzNumbers = Quran.getSurahVersesInJuzAsList(
      juzNumber,
    );
    juzSurahAyahStartNo.value = juzNumbers.first.startVerseNumber;
    pageNoJuz = quran.getPageNumber(surahNumber, juzSurahAyahStartNo.value);

    surahDetails.clear();
    surahDetails = getSurahDetailsInJuz(
      juzNumber: juzNumber,
      surahNumbers: surahNumbers,
    );

    return surahDetails;
  }

  getAythJuzNoTranslation({
    required int ayahCount,
    required int surahNo,
    required int juzNo,
  }) {
    surahJuzText = quran.getVerse(surahNo, ayahCount, verseEndSymbol: true);

    return surahJuzText;
  }

  getPageNoBySurah({required int surahNumber}) {
    if (surahNumber < 1 || surahNumber > 114) {
      throw Exception("Invalid Surah number: $surahNumber");
    } else {
      final surah = FlutterQuran().getSurah(surahNumber);
      surahStartPageNo = surah.startPage;
      surahEndPageNo = surah.endPage;
      surahBookmarkPageNo = surahStartPageNo;
    }
  }

  getSurahDetails({required int surahNo}) {
    ayahCountSurah = quran.getVerseCount(surahNo);
    surahVersesArabic = List.generate(
      ayahCountSurah,
      (i) => quran.getVerse(surahNo, i + 1),
    );
    surahVerseTranslation = List.generate(
      ayahCountSurah,
      (i) => getVerseTranslation(surahNo: surahNo, ayahNo: i + 1),
    );
    surahName = quran.getSurahName(surahNo);
  }

  getVerseTranslation({required int surahNo, required int ayahNo}) {
    final versesList = Quran.getVerse(
      surahNumber: surahNo,
      verseNumber: ayahNo,
      language: profileController.selectedLanguage.value,
    );
    return versesList.text;
  }

  // Returns a list of maps with Surah name and Ayah count within a specific Juz.
  List<Map<String, dynamic>> getSurahDetailsInJuz({
    required List<int> surahNumbers,
    required int juzNumber,
  }) {
    List<Map<String, dynamic>> surahDetails = [];
    for (int surahNumber in surahNumbers) {
      String surahNameEnglish = Quran.getSurahNameEnglish(surahNumber);
      int ayahCount = Quran.getTotalVersesOfSurahInJuz(
        surahNumber: surahNumber,
        juzNumber: juzNumber,
      );

      surahDetails.add({'surahName': surahNameEnglish, 'ayahCount': ayahCount});
    }
    return surahDetails;
  }
}
