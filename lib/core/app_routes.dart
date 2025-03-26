import 'package:get/get.dart';
import 'package:quran_hadith_app/boarding/view/home_screen.dart';
import 'package:quran_hadith_app/boarding/view/splash_screen.dart';
import 'package:quran_hadith_app/quran/view/juz_sreen.dart';
import 'package:quran_hadith_app/quran/view/quran_screen.dart';
import 'package:quran_hadith_app/quran/view/widgets/surah_screen.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: '/splash_screen', page: () => SplashScreen()),
    GetPage(name: '/quran_screen', page: () => QuranScreen()),
    GetPage(name: '/surah_screen', page: () => SurahScreen()),
    GetPage(name: '/home_screen', page: () => HomeScreen()),
    GetPage(name: '/juz_screen', page: () => JuzScreen()),
    //  GetPage(name: '/hadith_list_sreen', page: () => HadithListSreen()),
    // GetPage(
    //   name: '/hadith_detail_screen',
    //   page: () => HadithDetailScreen(),
    // ),
  ];
}
