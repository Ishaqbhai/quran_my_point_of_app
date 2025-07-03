import 'package:flutter/material.dart';
import 'package:flutter_quran/flutter_quran.dart';
import 'package:get/get.dart';
import 'package:quran/quran.dart';
import 'package:quran_hadith_app/boarding/controller/home_controller.dart';
import 'package:quran_hadith_app/bookmarks/controller/bookmark_controller.dart';
import 'package:quran_hadith_app/core/app_colors.dart';
import 'package:quran_hadith_app/quran/controller/audio_controller.dart';
import 'package:quran_hadith_app/quran/controller/quran_controller.dart';

class SurahPagesOfQuran extends StatelessWidget {
  final int surahNo;
  SurahPagesOfQuran({super.key, required this.surahNo});
  final QuranController quranController = Get.put(QuranController());
  final HomeController homeController = Get.find();
  final BookmarkController bookmarkController = Get.put(BookmarkController());
  final QuranAudioController controller = Get.put(QuranAudioController());

  @override
  Widget build(BuildContext context) {
    int pageNo = quranController.surahBookmarkPageNo;

    bookmarkController.checkSurahBookmarked(
      pageNo: pageNo,
      ayahNumber: null,
      surahNumber: surahNo,
      translation: quranController.surahTranslation.value,
    );

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .95,
            child: FlutterQuranScreen(
              onPageChanged: (int pageIndex) {
                pageNo = pageIndex;

                bookmarkController.checkSurahBookmarked(
                  pageNo: pageNo,
                  ayahNumber: null,
                  surahNumber: surahNo,
                  translation: quranController.surahTranslation.value,
                );

                if (pageIndex + 1 == quranController.surahEndPageNo + 1) {
                  Get.snackbar("Alert", "The surah Has compleated");
                  quranController.surahTranslation.value = true;
                  Get.offAllNamed('/surah_screen', arguments: surahNo);
                }
                final pageDetails = getPageData(pageIndex + 1);
                quranController.surahVerseNo = pageDetails[0]['end'];
                quranController.surahBookmarkPageNo = pageIndex;
              },
              appBar: AppBar(
                backgroundColor: AppColors().appBarColor,
                leading: IconButton(
                  onPressed: () {
                    quranController.surahTranslation.value = true;
                    Get.offAllNamed('/surah_screen', arguments: surahNo);
                  },
                  icon: Icon(Icons.arrow_back),
                ),
                actions: [
                  Obx(
                    () => IconButton(
                      splashRadius: 1,
                      icon: Icon(
                        controller.isPlaying.value
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: AppColors().appWhiteColor,
                      ),
                      iconSize: 30,
                      onPressed: () async {
                        controller.isPlaying.value
                            ? controller.pauseAudio()
                            : await controller.playAudioBySurah(
                              surahNumber: surahNo,
                            );
                      },
                    ),
                  ),

                  // **Stop Button**
                  Obx(
                    () => IconButton(
                      icon: Icon(Icons.stop, color: AppColors().appWhiteColor),
                      iconSize: 26,
                      splashRadius: 1,
                      onPressed:
                          controller.isPlaying.value
                              ? controller.stopAudio
                              : null,
                    ),
                  ),
                  Obx(
                    () => IconButton(
                      onPressed: () async {
                        bookmarkController.toggleSurahBookmark(
                          ayahNumber: null,
                          surahName: quranController.surahName,
                          surahNumber: surahNo,
                          translation: quranController.surahTranslation.value,
                          pageNo: pageNo,
                        );
                      },
                      icon: Icon(
                        Icons.bookmark,
                        color:
                            bookmarkController.isSurahMarked.value
                                ? Colors.red
                                : AppColors().appWhiteColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
