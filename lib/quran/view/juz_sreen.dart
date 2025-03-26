import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran/quran.dart' as quran;
import 'package:quran_hadith_app/boarding/controller/loading_controller.dart';
import 'package:quran_hadith_app/bookmarks/controller/bookmark_controller.dart';
import 'package:quran_hadith_app/core/app_colors.dart';
import 'package:quran_hadith_app/quran/controller/quran_controller.dart';
import 'package:quran_hadith_app/quran/controller/surah_search_controller.dart';
import 'package:quran_hadith_app/quran/view/audio_screen.dart';
import 'package:quran_hadith_app/quran/view/pages_of_quran.dart';

class JuzScreen extends StatelessWidget {
  JuzScreen({super.key});
  final BookmarkController bookmarkController = Get.put(BookmarkController());
  final QuranController quranController = Get.put(QuranController());
  final SurahSearchController searchController = Get.put(
    SurahSearchController(),
  );
  final loadingController = Get.find<LoadingController>();
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
            Get.back();
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
                              decoration: InputDecoration(
                                hintText: "Ayah",
                                // prefixIcon: Icon(
                                //   Icons.search,
                                //   color: Colors.grey,
                                // ),
                              ),
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
              return !quranController.juzTranslation.value
                  ? SingleChildScrollView(
                    child: Card(
                      color: AppColors().appWhiteColor,
                      margin: const EdgeInsets.symmetric(vertical: 1),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: PagesOfQuran(),
                      ),
                    ),
                  )
                  : Obx(() {
                    return ListView.builder(
                      key: ValueKey(searchController.surahNumberJuz.value),
                      itemCount:
                          surahNumbers.length
                          // -
                          // quranController.surahDetails.length,
                          -
                          searchController.surahNumberJuz.value,
                      itemBuilder: (context, k) {
                        // if (k >= surahNumbers.length) {
                        //   return const SizedBox();
                        // }
                        loadingController.showLoading();
                        int index = searchController.surahNumberJuz.value + k;
                        searchController.surahNumberJuz.value == index
                            ? searchController.j.value = 0
                            : searchController.j.value = 1;

                        int surahNumber = surahNumbers[index];

                        List<dynamic> verses = quranController.getVersesOfSurah(
                          surahNumber: surahNumber,
                        );

                        final surah = quran.getSurahName(surahNumber);

                        List<dynamic> translations = quranController
                            .getTranslationOfSurah(
                              surahNumber: surahNumber,
                              //surahNumbers[index],
                            );
                        int ayahCount =
                            quranController.surahDetails[index]['ayahCount'];
                        int startNo = quranController.juzSurahAyahStartNo.value;
                        loadingController.hideLoading();
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
                                    surah,
                                    //"${surahsInJuz[index]['surahName']}",
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
                              key: ValueKey(
                                quranController.juzSurahAyahStartNo,
                              ),

                              itemCount:
                                  searchController.j.value == 0
                                      ? (ayahCount - startNo).clamp(
                                        0,
                                        ayahCount,
                                      ) // Prevent negative values
                                      : ayahCount,
                              // ? quranController
                              //         .surahDetails[index]['ayahCount'] -
                              //     quranController
                              //         .juzSurahAyahStartNo
                              //         .value
                              // : quranController
                              //     .surahDetails[index]['ayahCount'],
                              itemBuilder: (context, i) {
                                // print(i);
                                int indexes =
                                    searchController.j.value == 0
                                        ? quranController
                                                .juzSurahAyahStartNo
                                                .value +
                                            i -
                                            1
                                        : i;
                                // searchController.j == 0
                                //     ? searchController
                                //             .satartingAyahNoJuz
                                //             .value +
                                //         i
                                //     : i;
                                if (indexes >= verses.length ||
                                    indexes >= translations.length) {
                                  return const SizedBox();
                                }
                                return verseTile(
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
                  });
            }),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: QuranAudioScreen(surah: false, juzNumber: juzNo),
          ),
        ],
      ),
    );
  }

  Widget verseTile({
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
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () {                  bookmarkController.saveJuzBookmark(
                    pageNumber: 0,
                    juzNumber: juzNumber,
                    surahNo: surahNumber,
                    endAyahNumber: 0,
                    translation: true,
                  );
                  Get.snackbar("BooKMark", "BookMark added ");
                },
                icon: Icon(Icons.bookmark, color: AppColors().bookmarkColor),
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
                style: TextStyle(fontSize: 16, color: AppColors().appBarColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
