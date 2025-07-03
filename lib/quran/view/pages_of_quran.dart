import 'package:flutter/material.dart';
import 'package:flutter_quran/flutter_quran.dart';
import 'package:get/get.dart';
import 'package:quran/quran.dart';
import 'package:quran_hadith_app/bookmarks/controller/bookmark_controller.dart';
import 'package:quran_hadith_app/core/app_colors.dart';
import 'package:quran_hadith_app/quran/controller/audio_controller.dart';
import 'package:quran_hadith_app/quran/controller/quran_controller.dart';
import 'package:quran_hadith_app/quran/view/juz_sreen.dart';

class PagesOfQuran extends StatelessWidget {
  PagesOfQuran({super.key, required this.juzNo});
  final BookmarkController bookmarkController = Get.put(BookmarkController());
  final QuranController quranController = Get.put(QuranController());
  final QuranAudioController controller = Get.put(QuranAudioController());
  final int juzNo;
  @override
  Widget build(BuildContext context) {
    int verseNumber = quranController.ayahStratingNo;
    int pageNo = quranController.pageNoJuz;

    bookmarkController.checkJuzBookMarked(
      juzNumber: juzNo,
      pageNumber: pageNo,
      endAyahNumber: verseNumber,
    );

    return PopScope(
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) {
        if (!didPop) {
          quranController.juzTranslation.value = true;
          // Only run if the system back button was pressed and pop was not handled yet
          Get.to(() => JuzScreen());
        }
      },
      child: Scaffold(
        body: FlutterQuranScreen(
          onPageChanged: (int pageIndex) {
            final pageDetails = getPageData(pageIndex + 1);
            verseNumber = pageDetails[0]['end'];
            quranController.surahTranslation.value = true;
            pageNo = pageIndex;
            bookmarkController.checkJuzBookMarked(
              juzNumber: juzNo,
              pageNumber: pageNo,
              endAyahNumber: verseNumber,
            );
          },
          appBar: AppBar(
            backgroundColor: AppColors().appBarColor,
            actions: [
              // Obx(
              //   () => IconButton(
              //     splashRadius: 1,
              //     icon: Icon(
              //       controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
              //       color: AppColors().appWhiteColor,
              //     ),
              //     iconSize: 30,
              //     onPressed: () async {
              //       controller.isPlaying.value
              //           ? controller.pauseAudio()
              //           : controller.playAudioByJuz(juzNumber: juzNo);
              //     },
              //   ),
              // ),

              // // **Stop Button**
              // Obx(
              //   () => IconButton(
              //     icon: Icon(Icons.stop, color: AppColors().appWhiteColor),
              //     iconSize: 26,
              //     splashRadius: 1,
              //     onPressed:
              //         controller.isPlaying.value ? controller.stopAudio : null,
              //   ),
              // ),
              Obx(
                () => IconButton(
                  onPressed: () async {
                    bookmarkController.toggleJuzBookmark(
                      surahNo: 0,
                      pageNumber: pageNo,
                      juzNumber: juzNo,
                      endAyahNumber: verseNumber,
                      translation: false,
                    );
                    await Future.delayed(const Duration(seconds: 5));
                    bookmarkController.checkJuzBookMarked(
                      juzNumber: juzNo,
                      pageNumber: pageNo,
                      endAyahNumber: verseNumber,
                    );
                  },
                  icon: Icon(
                    Icons.bookmark,
                    color:
                        bookmarkController.isJuzMarked.value
                            ? Colors.red
                            : AppColors().appWhiteColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
