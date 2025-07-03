import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_hadith_app/boarding/controller/loading_controller.dart';
import 'package:quran_hadith_app/bookmarks/controller/bookmark_controller.dart';
import 'package:quran_hadith_app/bookmarks/model/hadith_bookmark_model.dart';
import 'package:quran_hadith_app/hadith2/controller/hadith_controller.dart';
import 'package:quran_hadith_app/hadith2/view/hadith_detail_screen.dart';

class HadithBookmark extends StatelessWidget {
  HadithBookmark({super.key});
  final BookmarkController bookmarkController = Get.put(BookmarkController());
  final HadithController hadithController = Get.put(HadithController());
  final loadingController = Get.find<LoadingController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hadith Bookmark")),
      body: Stack(
        children: [
          Obx(() {
            return Center(
              child:
                  bookmarkController.hadithBookmarkList.isEmpty
                      ? Center(child: Text("No usedBookmarks yet"))
                      : ListView.builder(
                        itemCount: bookmarkController.hadithBookmarkList.length,
                        itemBuilder: (context, index) {
                          final HadithBookmarkModel bookmark =
                              bookmarkController.hadithBookmarkList[index];
                          return ListTile(
                            title: Text(
                              ' ${bookmark.collectionName} - BookNo ${bookmark.bookNo}',
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                bookmarkController.removeHadithBookmark(
                                  bookmark,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Bookmark deleted!')),
                                );
                              },
                            ),
                            onTap: () async {
                              loadingController.showLoading();
                              await Future.delayed(const Duration(seconds: 1));
                              // Navigate to the bookmarked Hadith
                              hadithController.fetchHadithBooks(
                                collection: bookmark.collectionName,
                              );
                              hadithController.fetchHadithList(
                                bookIndex: bookmark.bookNo,
                                noOfHadith: bookmark.totalNoOfHadith,
                              );
                              hadithController.hadithNo =
                                  bookmark.hadithaNo - 1;
                              loadingController.hideLoading();
                              Get.to(() => HadithDetailScreen());
                              await Future.delayed(const Duration(seconds: 5));
                              bookmarkController.removeHadithBookmark(bookmark);
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
