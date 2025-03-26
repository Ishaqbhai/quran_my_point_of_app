import 'package:flutter/material.dart';
import 'package:flutter_quran/flutter_quran.dart';
import 'package:get/get.dart';
import 'package:quran_hadith_app/bookmarks/controller/bookmark_controller.dart';

class DuaBookmark extends StatelessWidget {
  DuaBookmark({super.key});
  final BookmarkController bookmarkController = Get.put(BookmarkController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quran Juz Bookmark")),
      body: Obx(() {
        return Center(
          child:
              bookmarkController.usedBookmarks.isEmpty
                  ? Center(child: Text("No usedBookmarks yet"))
                  : ListView.builder(
                    itemCount: bookmarkController.usedBookmarks.length,
                    itemBuilder: (context, index) {
                      final Bookmark bookmark =
                          bookmarkController.usedBookmarks[index];
                      return ListTile(
                        title: Text(
                          'Surah ${bookmark.name} - Ayah ${bookmark.ayahId}',
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            FlutterQuran().removeBookmark(bookmarkId: 0);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Bookmark deleted!')),
                            );
                          },
                        ),
                        onTap: () {
                          // Navigate to the bookmarked Surah and Ayah
                          // int ayathCount = quranController.getTotalVersesOfSurah(
                          //   surahNumber: bookmark.surahNumber,
                          // );
                          // searchController.updateStartIndex(
                          //   ayatCount: ayathCount,
                          //   bookMark: true,
                          //   ayahNumber: bookmark.ayahNumber,
                          // );
                          // // Get.to(QuranAudioScreen());
                          // Get.toNamed('/surah_screen', arguments: index + 1);
                          // Get.toNamed(
                          //   '/surah_screen',
                          //   arguments: {
                          //     'surahNumber': bookmark.surahNumber,
                          //     'ayahNumber': bookmark.ayahNumber,
                          //   },
                          // );
                        },
                      );
                    },
                  ),
        );
      }),
    );
  }
}
