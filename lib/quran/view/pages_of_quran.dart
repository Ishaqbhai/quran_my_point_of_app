import 'package:flutter/material.dart';
import 'package:flutter_quran/flutter_quran.dart';
import 'package:get/get.dart';
import 'package:quran/quran.dart';
import 'package:quran_hadith_app/bookmarks/controller/bookmark_controller.dart';
import 'package:quran_hadith_app/core/app_colors.dart';
import 'package:quran_hadith_app/quran/controller/quran_controller.dart';

class PagesOfQuran extends StatelessWidget {
  PagesOfQuran({
    super.key,
    //  required this.verseNumber,
  });
  final BookmarkController bookmarkController = Get.put(BookmarkController());
  final QuranController quranController = Get.put(QuranController());
  // final usedBookmarks = FlutterQuran().getUsedBookmarks();
  @override
  Widget build(BuildContext context) {
    int verseNumber = quranController.ayahStratingNo;
    int pageNo = quranController.pageNoJuz;

    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * .95,
          child: FlutterQuranScreen(
            onPageChanged: (int pageIndex) {
              final pageDetails = getPageData(pageIndex + 1);
              // print("Ayah IDs on this page: $ayahIds");
              verseNumber = pageDetails[0]['end'];

              pageNo = pageIndex;
            },
            appBar: AppBar(
              backgroundColor: AppColors().appBarColor,
              actions: [
                IconButton(
                  onPressed: () {
                    bookmarkController.saveJuzBookmark(
                      surahNo: 0,
                      pageNumber: pageNo,
                      juzNumber: quranController.juzzNumber,
                      endAyahNumber: verseNumber,
                      translation: false,
                    );
                    // Example: Add bookmark for current page
                    // FlutterQuran().setBookmark(
                    //   ayahId: verseNumber,
                    //   page: pageNo, // Replace with actual page number
                    //   bookmarkId: 1,
                    // );
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
