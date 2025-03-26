import 'package:flutter/material.dart';
import 'package:flutter_quran/flutter_quran.dart';
import 'package:get/get.dart';
import 'package:quran/quran.dart';
import 'package:quran_hadith_app/boarding/controller/home_controller.dart';
import 'package:quran_hadith_app/boarding/view/home_screen.dart';
import 'package:quran_hadith_app/bookmarks/controller/bookmark_controller.dart';
import 'package:quran_hadith_app/core/app_colors.dart';
import 'package:quran_hadith_app/quran/controller/quran_controller.dart';

class SurahPagesOfQuran extends StatelessWidget {
  final int surahNo;
  SurahPagesOfQuran({super.key, required this.surahNo});
  final QuranController quranController = Get.put(QuranController());
  final usedBookmarks = FlutterQuran().getUsedBookmarks();
  final HomeController homeController = Get.find();
  final BookmarkController bookmarkController = Get.put(BookmarkController());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * .95,
          child: FlutterQuranScreen(
            onPageChanged: (int pageIndex) {
              if (pageIndex + 1 == quranController.surahEndPageNo + 1) {
                homeController.bottomNavIndex.value = 2;
                Get.off(HomeScreen());
              }
              final pageDetails = getPageData(pageIndex + 1);
              quranController.surahVerseNo = pageDetails[0]['end'];
              quranController.surahBookmarkPageNo = pageIndex;
            },
            appBar: AppBar(
              backgroundColor: AppColors().appBarColor,
              actions: [
                IconButton(
                  onPressed: () {
                    bookmarkController.saveSurahBookmark(
                      ayahNumber: quranController.ayahCountSurah,
                      surahName: quranController.surahName,
                      surahNumber: surahNo,
                      translation: quranController.surahTranslation.value,
                      pageNo: quranController.surahBookmarkPageNo + 1,
                    );
                    Get.snackbar("BooKMark", "BookMark added ");
                  },
                  icon: Icon(Icons.bookmark),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
