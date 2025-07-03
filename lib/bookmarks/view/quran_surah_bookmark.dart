import 'package:flutter/material.dart';
import 'package:flutter_quran/flutter_quran.dart';
import 'package:get/get.dart';
import 'package:quran_hadith_app/boarding/controller/loading_controller.dart';
import 'package:quran_hadith_app/bookmarks/controller/bookmark_controller.dart';
import 'package:quran_hadith_app/bookmarks/model/quran_surah_bookmark_model.dart';
import 'package:quran_hadith_app/quran/controller/quran_controller.dart';
import 'package:quran_hadith_app/quran/controller/surah_search_controller.dart';
import 'package:quran_hadith_app/quran/view/surah_pages_of_quran.dart';

class QuranSurahBookmark extends StatelessWidget {
  QuranSurahBookmark({super.key});

  final BookmarkController bookmarkController = Get.put(BookmarkController());
  final QuranController quranController = Get.put(QuranController());
  final SurahSearchController searchController = Get.put(
    SurahSearchController(),
  );
  final loadingController = Get.find<LoadingController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quran Surah Bookmark")),
      body: Stack(
        children: [
          Obx(() {
            return Center(
              child:
                  bookmarkController.surahBookmarkList.isEmpty
                      ? Center(child: Text("No usedBookmarks yet"))
                      : ListView.builder(
                        itemCount: bookmarkController.surahBookmarkList.length,
                        itemBuilder: (context, index) {
                          final QuranSurahBookmarkModel bookmark =
                              bookmarkController.surahBookmarkList[index];
                          return ListTile(
                            title:
                                bookmark.pageNo != null
                                    ? Text(
                                      'Surah ${bookmark.surahName} - PageNo ${bookmark.pageNo}',
                                    )
                                    : Text(
                                      'Surah ${bookmark.surahName} - Ayah ${bookmark.ayahNumber}',
                                    ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                bookmarkController.removeSurahBookmark(
                                  bookmark: bookmark,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Bookmark deleted!')),
                                );
                              },
                            ),
                            onTap: () async {
                              loadingController.showLoading();
                              await Future.delayed(const Duration(seconds: 1));
                              quranController.getTotalVersesOfSurah(
                                surahNumber: bookmark.surahNumber,
                              );
                              await quranController.getPageNoBySurah(
                                surahNumber: bookmark.surahNumber,
                              );
                              quranController.quranListIndex.value == 0;
                              if (bookmark.pageNo == null) {
                                FlutterQuran().navigateToSurah(
                                  bookmark.surahNumber,
                                );
                                searchController.updateStartIndex(
                                  ayatCount: quranController.ayahCountSurah,
                                  bookMark: true,
                                  ayahNumber: bookmark.ayahNumber!,
                                );
                              } else {
                                FlutterQuran().navigateToPage(bookmark.pageNo!);
                              }
                              quranController.surahTranslation.value =
                                  bookmark.translation;
                              quranController.getSurahDetails(
                                surahNo: bookmark.surahNumber,
                              );

                              loadingController.hideLoading();
                              bookmark.pageNo == null
                                  ? Get.toNamed(
                                    '/surah_screen',
                                    arguments: bookmark.surahNumber,
                                  )
                                  : Get.to(
                                    SurahPagesOfQuran(
                                      surahNo: bookmark.pageNo!,
                                    ),
                                  );
                              await Future.delayed(const Duration(seconds: 5));
                              bookmarkController.removeSurahBookmark(
                                bookmark: bookmark,
                              );
                            },
                          );
                        },
                      ),
            );
          }),
          Obx(() {
            return loadingController.isLoading.value
                ? Container(
                  color: Colors.black54,
                  child: const Center(child: CircularProgressIndicator()),
                )
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
