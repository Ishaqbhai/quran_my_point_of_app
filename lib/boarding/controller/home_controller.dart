import 'package:flutter/material.dart';
import 'package:flutter_quran/flutter_quran.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quran_hadith_app/bookmarks/model/hadith_bookmark_model.dart';
import 'package:quran_hadith_app/bookmarks/model/juz_bookmark_model.dart';
import 'package:quran_hadith_app/bookmarks/model/quran_surah_bookmark_model.dart';

class HomeController extends GetxController {
  RxInt bottomNavIndex = 0.obs;
  @override
  void onInit() {
    super.onInit();
    goToRegistration();
  }

  changeBottomNavIndex({required int index}) {
    bottomNavIndex.value = index;
  }

  Future<void> goToRegistration() async {
    await Future.delayed(const Duration(seconds: 5));

    FlutterQuran().init(
      userBookmarks: [
        Bookmark(id: 1, colorCode: Colors.teal.hashCode, name: "Red Bookmark"),
      ],
    );
    await Hive.initFlutter(); // Initialize Hive
    Hive.registerAdapter(QuranSurahBookmarkModelAdapter());
    Hive.registerAdapter(HadithBookmarkModelAdapter());
    Hive.registerAdapter(JuzBookmarkModelAdapter());

    await Hive.openBox<QuranSurahBookmarkModel>('QuranBookmarks');
    await Hive.openBox<HadithBookmarkModel>('HadithBookmarks');
    await Hive.openBox<JuzBookmarkModel>('JuzBookmarks');
    Get.toNamed('/home_screen');
  }
}
