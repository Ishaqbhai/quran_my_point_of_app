import 'package:flutter/material.dart';
import 'package:flutter_quran/flutter_quran.dart';
import 'package:get/get.dart';
import 'package:quran/quran.dart' as quran;
import 'package:quran_hadith_app/boarding/controller/home_controller.dart';
import 'package:quran_hadith_app/boarding/view/home_screen.dart';
import 'package:quran_hadith_app/bookmarks/controller/bookmark_controller.dart';
import 'package:quran_hadith_app/core/app_colors.dart';
import 'package:quran_hadith_app/quran/controller/audio_controller.dart';
import 'package:quran_hadith_app/quran/controller/quran_controller.dart';
import 'package:quran_hadith_app/quran/controller/surah_search_controller.dart';
import 'package:quran_hadith_app/quran/view/pages_of_quran.dart';

class JuzScreen extends StatelessWidget {
  JuzScreen({super.key});
  final BookmarkController bookmarkController = Get.put(BookmarkController());
  final QuranController quranController = Get.put(QuranController());
  final QuranAudioController controller = Get.put(QuranAudioController());
  final HomeController homeController = Get.put(HomeController());
  final SurahSearchController searchController = Get.put(
    SurahSearchController(),
  );

  @override
  Widget build(BuildContext context) {
    final int juzNo = Get.arguments;
    // Access juzData correctly
    var juz = QuranController.juzData[juzNo - 1];

    List<int> surahNumbers = juz["surahs"] ?? [];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            searchController.ayahJuzzController.clear();
            homeController.changeBottomNavIndex(index: 0);
            quranController.changequranListIndex(index: 1);
            Get.offAll(HomeScreen());
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Juz $juzNo'),
        centerTitle: true,
      ),
      body: Column(
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
                      value: quranController.juzTranslation.value,
                      onChanged: (value) {
                        quranController.juzTranslation.value = value;
                        if (quranController.juzTranslation.value == false) {
                          FlutterQuran().navigateToJozz(juzNo);
                          Get.to(() => PagesOfQuran(juzNo: juzNo));
                        }
                      },
                    ),
                  ),
                ],
              ),
              Obx(() {
                return quranController.surahTranslation.value == true
                    ? Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: DropdownButtonFormField<int>(
                            value:
                                surahNumbers.isNotEmpty
                                    ? 0
                                    : null, // Default value is the first index
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                            ),
                            items:
                                surahNumbers.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  int surah = entry.value;
                                  return DropdownMenuItem<int>(
                                    value: index, // Use index as value
                                    child: Text(
                                      surah.toString(),
                                    ), // Display actual Surah number
                                  );
                                }).toList(),
                            onChanged: (int? newIndex) {
                              if (newIndex != null) {
                                searchController.surahNumberJuz.value =
                                    newIndex;
                              }
                            },
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: TextField(
                              onChanged: searchController.filterAyahsJuz,
                              controller: searchController.ayahJuzzController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(hintText: "Ayah"),
                            ),
                          ),
                        ),
                      ],
                    )
                    : SizedBox.shrink();
              }),
            ],
          ),
          Expanded(
            child: Obx(() {
              surahNumbers.asMap().entries.map((entry) {
                if (entry.value == searchController.bookmarkSurahNo.value) {
                  searchController.surahNumberJuz.value = entry.key;
                }
              });

              return ListView.builder(
                key: ValueKey(searchController.surahNumberJuz.value),
                itemCount:
                    surahNumbers.length - searchController.surahNumberJuz.value,
                itemBuilder: (context, k) {
                  int index = searchController.surahNumberJuz.value + k;
                  searchController.surahNumberJuz.value == index
                      ? searchController.j.value = 0
                      : searchController.j.value = 1;

                  int surahNumber =
                      searchController.isBookMark.value
                          ? searchController.bookmarkSurahNo.value
                          : surahNumbers[index];

                  List<dynamic> verses = quranController.getVersesOfSurah(
                    surahNumber: surahNumber,
                  );

                  final surahName = quran.getSurahName(surahNumber);

                  List<dynamic> translations = quranController
                      .getTranslationOfSurah(surahNumber: surahNumber);
                  int ayahCount =
                      quranController.surahDetails[index]['ayahCount'];

                  return Column(
                    children: [
                      // Surah Name Header
                      Container(
                        width: double.infinity,
                        color: AppColors().appBarColor,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              surahName,
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors().appWhiteColor,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Verses List
                      ListView.builder(
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(), // Prevent inner scrolling
                        key: ValueKey(quranController.juzSurahAyahStartNo),

                        itemCount: ayahCount,

                        itemBuilder: (context, i) {
                          int indexes =
                              searchController.j.value == 0
                                  ? quranController.juzSurahAyahStartNo.value +
                                      i -
                                      1
                                  : i;

                          if (indexes >= verses.length ||
                              indexes >= translations.length) {
                            return const SizedBox();
                          }
                          return verseTile(
                            ayahNo: verses[indexes].verseNumber,
                            juzNumber: juzNo,
                            surahNumber: surahNumbers[index],
                            arabic: verses[indexes].text,
                            translation:
                                "${indexes + 1}. ${translations[indexes].text}",
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget verseTile({
    required int ayahNo,
    required String arabic,
    required String translation,
    required int juzNumber,
    required int surahNumber,
  }) {
    return Container(
      color: AppColors().appWhiteColor,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                GetBuilder<BookmarkController>(
                  builder: (_) {
                    final isMarked = bookmarkController.isJuzBookmarked(
                      juzNumber: juzNumber,
                      surahNumber: surahNumber,
                      endAyahNumber: ayahNo,
                    );

                    return IconButton(
                      onPressed: () {
                        bookmarkController.toggleJuzBookmark(
                          pageNumber: 0,
                          juzNumber: juzNumber,
                          surahNo: surahNumber,
                          endAyahNumber: ayahNo,
                          translation: true,
                        );
                      },
                      icon: Icon(
                        Icons.bookmark,
                        color:
                            isMarked ? Colors.red : AppColors().bookmarkColor,
                      ),
                    );
                  },
                ),

                Obx(
                  () => IconButton(
                    splashRadius: 1,
                    icon: Icon(
                      (controller.currentIntex.value == ayahNo &&
                              controller.isPlaying.value == true)
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: AppColors().bookmarkColor,
                    ),
                    iconSize: 32,
                    onPressed: () async {
                      controller.currentIntex.value = ayahNo;
                      controller.isPlaying.value
                          ? controller.pauseAudio()
                          : controller.playAudioByAyah(
                            ayahNo: ayahNo,
                            surahNo: surahNumber,
                          );
                    },
                  ),
                ),

                // **Stop Button**
                Obx(
                  () => IconButton(
                    icon: Icon(Icons.stop, color: AppColors().bookmarkColor),
                    iconSize: 28,
                    splashRadius: 1,
                    onPressed:
                        controller.isPlaying.value
                            ? controller.stopAudio
                            : null,
                  ),
                ),
              ],
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
          ],
        ),
      ),
    );
  }
}
