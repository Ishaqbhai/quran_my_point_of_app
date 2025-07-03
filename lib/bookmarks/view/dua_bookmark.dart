import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_hadith_app/bookmarks/controller/bookmark_controller.dart';
import 'package:quran_hadith_app/bookmarks/model/dua_bookmark_model.dart';
import 'package:quran_hadith_app/dua/controller/dua_controller.dart';
import 'package:quran_hadith_app/dua/view/dua_details.dart';

class DuaBookmark extends StatelessWidget {
  DuaBookmark({super.key});
  final BookmarkController bookmarkController = Get.put(BookmarkController());
  final DuaController duaController = Get.put(DuaController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quran Juz Bookmark")),
      body: Obx(() {
        return Center(
          child:
              bookmarkController.duaBookmarkList.isEmpty
                  ? Center(child: Text("No usedBookmarks yet"))
                  : ListView.builder(
                    itemCount: bookmarkController.duaBookmarkList.length,
                    itemBuilder: (context, index) {
                      final DuaBookmarkModel bookmark =
                          bookmarkController.duaBookmarkList[index];
                      return ListTile(
                        title: Text('Dua ${bookmark.duaTitle}'),
                        subtitle: Text(bookmark.category),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            bookmarkController.removeDuaBookmark(bookmark);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Bookmark deleted!')),
                            );
                          },
                        ),
                        onTap: () async {
                          duaController.fetchDuasByCategory(bookmark.category);
                          Get.to(
                            () => DuaDetails(categoryName: bookmark.category),
                          );
                          // Get.to(
                          //   BookmarkedDua(
                          //     categoryName: bookmark.category,
                          //     listIndex: bookmark.duaIndex,
                          //   ),
                          await Future.delayed(
                            const Duration(seconds: 5),
                          ); // );

                          bookmarkController.removeDuaBookmark(bookmark);
                        },
                      );
                    },
                  ),
        );
      }),
    );
  }
}
