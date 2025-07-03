import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_flutter/quran.dart';
import 'package:quran_flutter/models/surah.dart';
import 'package:quran_hadith_app/quran/controller/quran_controller.dart';

class SurahSearchController extends GetxController {
  var allSurahs = <Surah>[].obs;
  var filteredSurahs = <Surah>[].obs;
  var searchText = "".obs;
  var searchAyahText = "".obs;
  final TextEditingController ayahController = TextEditingController();
  final TextEditingController ayahJuzzController = TextEditingController();
  final TextEditingController surahJuzzController = TextEditingController();
  RxInt startIndex = 0.obs;
  RxInt ayatCount = 0.obs;
  RxInt satartingAyahNoJuz = 0.obs;
  RxInt surahNumberJuz = 0.obs;
  RxInt j = 1.obs;
  final QuranController quranController = Get.put(QuranController());
  RxBool loading = false.obs;
  RxBool isBookMark = false.obs;
  RxInt bookmarkSurahNo = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadSurahs();
  }

  @override
  void dispose() {
    startIndex.value = 0;
    ayatCount.value = 0;
    satartingAyahNoJuz.value = 0;
    surahNumberJuz.value = 0;
    searchText.value = "";
    searchAyahText.value = "";
    ayahController.dispose();
    ayahJuzzController.dispose();
    surahJuzzController.dispose();
    super.dispose();
  }

  void clear() {
    startIndex.value = 0;
    ayatCount.value = 0;
    satartingAyahNoJuz.value = 0;
    surahNumberJuz.value = 0;
    searchText.value = "";
    searchAyahText.value = "";
  }

  void loadSurahs() {
    allSurahs.assignAll(
      List.generate(Quran.surahCount, (index) {
        int surahNumber = index + 1;
        return Quran.getSurah(surahNumber);
      }),
    );
    filteredSurahs.assignAll(allSurahs);
  }

  void updateStartIndex({
    required int ayatCount,
    required bool bookMark,
    int ayahNumber = 0,
  }) {
    int? ayahNo = bookMark ? ayahNumber : int.tryParse(ayahController.text);
    if (ayahNo != null && ayahNo > 0 && ayahNo <= ayatCount) {
      startIndex.value = ayahNo - 1; // Set ListView starting index
    }
  }

  void filterSurahs(String query) {
    searchText.value = query;
    if (query.isEmpty) {
      filteredSurahs.assignAll(allSurahs);
    } else {
      filteredSurahs.assignAll(
        allSurahs.where(
          (surah) =>
              surah.name.toLowerCase().contains(
                query.toLowerCase(),
              ) || // Arabic name
              surah.nameEnglish.toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
  }

  void filterAyahs(String query) {
    searchAyahText.value = query;
    if (query.isEmpty) {
      startIndex.value = 1;
    } else {
      updateStartIndex(
        ayatCount: quranController.ayahCountSurah,
        bookMark: false,
      );
    }
  }

  void filterAyahsJuz(String query) {
    if (query.isEmpty || query == "") {
      quranController.juzSurahAyahStartNo.value = 1;
    } else {
      quranController.juzSurahAyahStartNo.value = int.parse(query);
      j.value = 0;
    }
  }

  void updateStartIndexJuz({int ayahNumber = 0}) {
    int ayahNumber = int.tryParse(ayahJuzzController.text) ?? 0;
    satartingAyahNoJuz.value = ayahNumber - 1;
  }
}
