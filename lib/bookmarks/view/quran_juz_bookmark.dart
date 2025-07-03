import 'package:flutter/material.dart';
import 'package:flutter_quran/flutter_quran.dart';
import 'package:get/get.dart';
import 'package:quran_hadith_app/boarding/controller/loading_controller.dart';
import 'package:quran_hadith_app/bookmarks/controller/bookmark_controller.dart';
import 'package:quran_hadith_app/bookmarks/model/juz_bookmark_model.dart';
import 'package:quran_hadith_app/quran/controller/quran_controller.dart';
import 'package:quran_hadith_app/quran/controller/surah_search_controller.dart';
import 'package:quran_hadith_app/quran/view/pages_of_quran.dart';

class QuranJuzBookmark extends StatelessWidget {
  QuranJuzBookmark({super.key});

  final QuranController quranController = Get.put(QuranController());
  final BookmarkController bookmarkController = Get.put(BookmarkController());
  final loadingController = Get.find<LoadingController>();
  final SurahSearchController searchController = Get.put(
    SurahSearchController(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quran Juz Bookmark")),
      body: Stack(
        children: [
          Obx(() {
            return Center(
              child:
                  bookmarkController.juzBookmarkList.isEmpty
                      ? Center(child: Text("No usedBookmarks yet"))
                      : ListView.builder(
                        itemCount: bookmarkController.juzBookmarkList.length,
                        itemBuilder: (context, index) {
                          final JuzBookmarkModel bookmark =
                              bookmarkController.juzBookmarkList[index];
                          return ListTile(
                            title:
                                bookmark.pageNumber == 0
                                    ? Text(
                                      'Juz ${bookmark.juzNumber} - Surah number ${bookmark.surahNumber + 1}',
                                    )
                                    : Text(
                                      'Juz ${bookmark.juzNumber} - Page ${bookmark.pageNumber! + 1}',
                                    ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                bookmarkController.removeJuzBookmark(bookmark);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Bookmark deleted!')),
                                );
                              },
                            ),
                            onTap: () async {
                              loadingController.showLoading();
                              await Future.delayed(const Duration(seconds: 1));
                              quranController.quranListIndex.value = 1;
                              quranController.juzTranslation.value = false;
                              searchController.isBookMark.value = true;
                              searchController.bookmarkSurahNo.value =
                                  bookmark.surahNumber;
                              if (bookmark.surahNumber != 0) {
                                quranController.juzTranslation.value = true;
                                quranController.getNoOfVersesInJuz(
                                  juzNumber: bookmark.juzNumber,
                                  surahNumber: bookmark.surahNumber,
                                );
                              }
                              FlutterQuran().navigateToPage(
                                bookmark.pageNumber! + 1,
                              );
                              searchController.updateStartIndexJuz(
                                ayahNumber: bookmark.endAyahNumber!,
                              );
                              // searchController.surahNumberJuz.value =
                              //     bookmark.juzNumber;
                              searchController.ayahJuzzController.text =
                                  bookmark.endAyahNumber!.toString();

                              quranController.juzSurahAyahStartNo.value =
                                  bookmark.endAyahNumber!;
                              searchController.startIndex.value =
                                  bookmark.endAyahNumber!;
                              //FlutterQuran().navigateToJozz(bookmark.juzNumber);
                              searchController.j.value = 0;
                              quranController.pageNoJuz = bookmark.pageNumber!;
                              loadingController.hideLoading();
                              bookmark.surahNumber != 0
                                  ? Get.toNamed(
                                    '/juz_screen',
                                    arguments: bookmark.juzNumber,
                                  )
                                  : Get.to(
                                    PagesOfQuran(juzNo: bookmark.juzNumber),
                                  );
                              await Future.delayed(const Duration(seconds: 5));
                              bookmarkController.removeJuzBookmark(bookmark);
                             
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
