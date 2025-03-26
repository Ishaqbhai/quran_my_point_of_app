import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_hadith_app/boarding/controller/home_controller.dart';
import 'package:quran_hadith_app/boarding/view/home_screen.dart';
import 'package:quran_hadith_app/bookmarks/controller/bookmark_controller.dart';
import 'package:quran_hadith_app/core/app_colors.dart';
import 'package:quran_hadith_app/quran/controller/quran_controller.dart';
import 'package:quran_hadith_app/quran/controller/surah_search_controller.dart';
import 'package:quran_hadith_app/quran/view/audio_screen.dart';
import 'package:quran_hadith_app/quran/view/widgets/surah_detail_screen.dart';

class SurahScreen extends StatelessWidget {
  SurahScreen({super.key});

  final QuranController quranController = Get.find();

  final SurahSearchController searchController = Get.put(
    SurahSearchController(),
  );
  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    final int surahNo = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            homeController.bottomNavIndex.value = 2;
            Get.off(HomeScreen());
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              quranController.surahName,
              style: const TextStyle(fontSize: 18),
            ),
            Obx(() {
              return quranController.surahTranslation.value == true
                  ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextField(
                        onChanged: searchController.filterAyahs,
                        controller: searchController.ayahController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Ayah",
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                        ),
                      ),
                    ),
                  )
                  : SizedBox.shrink();
            }),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      "Translation",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Obx(
                      () => Switch(
                        activeTrackColor: AppColors().appBarColor,
                        inactiveThumbColor: AppColors().appBarColor,
                        inactiveTrackColor: AppColors().backgroundColor,
                        value: quranController.surahTranslation.value,
                        onChanged: (value) {
                          quranController.surahTranslation.value = value;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Obx(() {
              return quranController.surahTranslation.value == false
                  ? Expanded(child: SurahDetailScreen(surahNumber: surahNo))
                  : Expanded(
                    child: ListView.builder(
                      key: ValueKey(searchController.startIndex),
                      itemCount:
                          quranController.ayahCountSurah -
                          searchController.startIndex.value,
                      itemBuilder: (context, i) {
                        int index = searchController.startIndex.value + i;
                        return verseTile(
                          surahName: quranController.surahName,
                          arabic: quranController.surahVersesArabic[index],
                          translation:
                              "${index + 1}. ${quranController.surahVerseTranslation[index]}",
                          surahNo: surahNo,
                          ayatNo: index + 1,
                          context: context,
                        );
                      },
                    ),
                    //   ),
                    // ],
                  );
            }),
            SizedBox(
              height: 90,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: QuranAudioScreen(surahNumber: surahNo, surah: true),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget verseTile({
    required String arabic,
    required String translation,
    required int surahNo,
    required int ayatNo,
    required BuildContext context,
    required String surahName,
  }) {
    final BookmarkController bookmarkController = Get.put(BookmarkController());
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () {
                      bookmarkController.saveSurahBookmark(
                        surahName: surahName,
                        ayahNumber: ayatNo,
                        surahNumber: surahNo,
                        translation: quranController.surahTranslation.value,
                        pageNo: null,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Bookmark saved for $surahName!'),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.bookmark,
                      color: AppColors().bookmarkColor,
                    ),
                  ),
                ),
                Text(
                  arabic,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'TraditionalArabic',
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 10),
                quranController.surahTranslation.value
                    ? Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        translation,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors().bookmarkColor,
                        ),
                      ),
                    )
                    : const SizedBox.shrink(),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      );
    });
  }
}
