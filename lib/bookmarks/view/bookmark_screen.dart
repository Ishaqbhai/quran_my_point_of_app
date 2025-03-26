import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_hadith_app/bookmarks/view/hadith_bookmark.dart';
import 'package:quran_hadith_app/bookmarks/view/quran_juz_bookmark.dart';
import 'package:quran_hadith_app/bookmarks/view/quran_surah_bookmark.dart';
import 'package:quran_hadith_app/core/app_colors.dart';
import 'package:quran_hadith_app/quran/controller/quran_controller.dart';

class BookmarksScreen extends StatelessWidget {
  final QuranController quranController = Get.put(QuranController());

  BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: SizedBox.shrink(), title: Text('Bookmarks')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .4,
                    height: MediaQuery.of(context).size.height * .1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors().appWhiteColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(child: Text("Quran-Juz")),
                    ),
                  ),
                ),
                onTap: () {
                  Get.to(QuranJuzBookmark());
                },
              ),
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .4,
                    height: MediaQuery.of(context).size.height * .1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors().appWhiteColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(child: Text("Quran-Surah")),
                    ),
                  ),
                ),
                onTap: () {
                  Get.to(() => QuranSurahBookmark());
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .4,
                    height: MediaQuery.of(context).size.height * .1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors().appWhiteColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(child: Text("Hadith")),
                    ),
                  ),
                ),
                onTap: () {
                  Get.to(HadithBookmark());
                },
              ),

              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * .4,
                    height: MediaQuery.of(context).size.height * .1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors().appWhiteColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(child: Text("Dua")),
                    ),
                  ),
                ),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
