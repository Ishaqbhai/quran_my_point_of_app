import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:quran_hadith_app/Profile/view/profile_screen.dart';
import 'package:quran_hadith_app/boarding/controller/home_controller.dart';
import 'package:quran_hadith_app/bookmarks/view/bookmark_screen.dart';
import 'package:quran_hadith_app/core/app_colors.dart';
import 'package:quran_hadith_app/dua/view/dua_screen.dart';
import 'package:quran_hadith_app/hadith2/view/hadith_screen.dart';
import 'package:quran_hadith_app/quran/view/quran_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final HomeController homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () =>
            homeController.bottomNavIndex.value == 0
                ? DuaScreen()
                : homeController.bottomNavIndex.value == 1
                ?
                // BooksScreen()
                HadithScreen()
                : homeController.bottomNavIndex.value == 2
                ? QuranScreen()
                : homeController.bottomNavIndex.value == 3
                ? BookmarksScreen()
                : homeController.bottomNavIndex.value == 4
                ? ProfileScreen()
                : CircularProgressIndicator(),
      ),
      bottomNavigationBar: ConvexAppBar(
        height: 60,
        backgroundColor: AppColors().appBarColor,
        items: [
          TabItem(icon: Icons.book, title: "Dua"),
          TabItem(icon: Icons.menu_book, title: "Hadith"),
          TabItem(icon: Icons.menu_book_rounded, title: "Quran"),
          TabItem(icon: Icons.bookmark, title: "Marks"),
          TabItem(icon: Icons.person, title: "Profile"),
        ],
        onTap: (int i) => homeController.changeBottomNavIndex(index: i),
      ),
    );
  }
}
