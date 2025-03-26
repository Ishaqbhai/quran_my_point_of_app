// hadith_detail_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_hadith_app/bookmarks/controller/bookmark_controller.dart';
import 'package:quran_hadith_app/core/app_colors.dart';
import 'package:quran_hadith_app/hadith2/controller/hadith_controller.dart';
import 'package:quran_hadith_app/hadith2/view/hadith_book_screen.dart';

class HadithDetailScreen extends StatelessWidget {
  final HadithController hadithController = Get.put(HadithController());

  HadithDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            hadithController.clearHadithList();
            hadithController.hadithNo = 0;
            Get.to(HadithBookScreen(title: hadithController.collectionName));
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Hadith Details'),
      ),
      body: Obx(() {
        return hadithController.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : hadithController.hadithList.isEmpty
            ? Center(child: Text('No Hadiths found.'))
            : ListView.builder(
              itemCount:
                  hadithController.hadithList.length -
                  hadithController.hadithNo,
              itemBuilder: (context, i) {
                int index = hadithController.hadithNo + i;
                final hadith = hadithController.hadithList[index];
                return verseTile(
                  index: index + 1,
                  arabic: hadith.arabic,
                  translation: hadith.english,
                  context: context,

                  hadithIndex: index,
                );
              },
            );
      }),
    );
  }

  Widget verseTile({
    required String arabic,
    required String translation,
    required int index,
    required BuildContext context,
    required int hadithIndex,
  }) {
    final BookmarkController controller = Get.put(BookmarkController());
    // return Obx(() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {
                    controller.saveHadithBookmark(
                      bookNumber: hadithController.bookNumber,
                      collectionName: hadithController.collectionName,
                      hadithNumber: index,
                      noOfHadith: hadithController.totalNumberOfHadith,
                      // startHadithNo: hadithController.startHadithCount,
                      // endHadithNo: hadithController.endHadithCound,
                      translation: true,
                    );
                    //......................................................................
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Bookmark saved for Hadith')),
                    );
                  },
                  icon: Icon(Icons.bookmark, color: AppColors().bookmarkColor),
                ),
              ),
              Text(
                arabic,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Amiri',
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 10),
              //      controller.surahTranslation.value
              //         ?
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "$index. $translation",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors().appBarColor,
                  ),
                ),
              ),
              // : SizedBox.shrink(),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
    //   });
  }
}
