import 'package:flutter_quran/flutter_quran.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quran_hadith_app/bookmarks/model/dua_bookmark_model.dart';
import 'package:quran_hadith_app/bookmarks/model/hadith_bookmark_model.dart';
import 'package:quran_hadith_app/bookmarks/model/juz_bookmark_model.dart';
import 'package:quran_hadith_app/bookmarks/model/quran_surah_bookmark_model.dart';

class HomeController extends GetxController {
  RxInt bottomNavIndex = 0.obs;
  @override
  void onInit() {
    FlutterQuran().init();
    super.onInit();
    goToRegistration();
  }

  changeBottomNavIndex({required int index}) {
    bottomNavIndex.value = index;
  }

  Future<void> goToRegistration() async {
    await Future.delayed(const Duration(seconds: 1));

    await Hive.initFlutter(); // Initialize Hive
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(QuranSurahBookmarkModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(HadithBookmarkModelAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(JuzBookmarkModelAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(DuaBookmarkModelAdapter());
    }

    await Hive.openBox<QuranSurahBookmarkModel>('QuranBookmarks');
    await Hive.openBox<HadithBookmarkModel>('HadithBookmarks');
    await Hive.openBox<JuzBookmarkModel>('JuzBookmarks');
    await Hive.openBox<DuaBookmarkModel>('DuaBookmarks');
    await Hive.openBox('AuthorLogin');
    Get.toNamed('/home_screen');
  }
}
