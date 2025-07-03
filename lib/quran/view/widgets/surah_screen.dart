import 'package:flutter/material.dart';
import 'package:flutter_quran/flutter_quran.dart';
import 'package:get/get.dart';
import 'package:quran_hadith_app/boarding/controller/home_controller.dart';
import 'package:quran_hadith_app/boarding/view/home_screen.dart';
import 'package:quran_hadith_app/bookmarks/controller/bookmark_controller.dart';
import 'package:quran_hadith_app/core/app_colors.dart';
import 'package:quran_hadith_app/quran/controller/quran_controller.dart';
import 'package:quran_hadith_app/quran/controller/surah_search_controller.dart';
import 'package:quran_hadith_app/quran/view/audio_screen.dart';
import 'package:quran_hadith_app/quran/view/surah_pages_of_quran.dart';

class SurahScreen extends StatelessWidget {
  SurahScreen({super.key});

  final QuranController quranController = Get.find();

  final SurahSearchController searchController = Get.put(
    SurahSearchController(),
  );
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final int surahNo = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            homeController.changeBottomNavIndex(index: 0);
            quranController.changequranListIndex(index: 0);
            Get.offAll(HomeScreen());
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
                          if (quranController.surahTranslation.value == false) {
                            FlutterQuran().navigateToSurah(surahNo);
                            Get.to(() => SurahPagesOfQuran(surahNo: surahNo));
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Expanded(
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
            ),
            SizedBox(
              height: 90,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: QuranAudioScreen(
                  surahNumber: surahNo,
                  surah: true,
                  surahName: quranController.surahName,
                ),
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
    Get.put(BookmarkController());

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: GetBuilder<BookmarkController>(
            builder: (bookmarkController) {
              RxBool isMarked =
                  bookmarkController
                      .isSurahBookmarked(
                        ayahNumber: ayatNo,
                        surahNumber: surahNo,

                        translation: quranController.surahTranslation.value,
                      )
                      .obs;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      bookmarkController.toggleSurahBookmark(
                        surahNumber: surahNo,
                        ayahNumber: ayatNo,
                        pageNo: null,
                        translation: quranController.surahTranslation.value,
                        surahName: surahName,
                      );
                      isMarked.value = bookmarkController.isSurahBookmarked(
                        ayahNumber: ayatNo,
                        surahNumber: surahNo,

                        translation: quranController.surahTranslation.value,
                      );
                    },
                    icon: Icon(
                      Icons.bookmark,
                      color:
                          isMarked.value
                              ? Colors.red
                              : AppColors().bookmarkColor,
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
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      translation,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors().appTranslationColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
