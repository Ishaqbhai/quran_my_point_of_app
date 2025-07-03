import 'package:double_tap_to_exit/double_tap_to_exit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_hadith_app/core/app_colors.dart';
import 'package:quran_hadith_app/quran/controller/quran_controller.dart';
import 'package:quran_hadith_app/quran/controller/surah_search_controller.dart';
import 'package:quran_hadith_app/quran/view/widgets/juz_list.dart';
import 'package:quran_hadith_app/quran/view/widgets/surah_list.dart';
import 'package:toggle_switch/toggle_switch.dart';

class QuranScreen extends StatelessWidget {
  QuranScreen({super.key});

  final SurahSearchController searchController = Get.put(
    SurahSearchController(),
  );
  final QuranController quranController = Get.put(QuranController());

  @override
  Widget build(BuildContext context) {
    return DoubleTapToExit(
      child: PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(
            leading: SizedBox.shrink(),
            title: Text("Quran", style: GoogleFonts.poppins()),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // 🔍 Search Bar
                TextField(
                  onChanged: searchController.filterSurahs,
                  decoration: InputDecoration(
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                  ),
                ),
                SizedBox(height: 16),

                // 📌 TabBar (Surah / Juz)
                Obx(
                  () => ToggleSwitch(
                    minWidth: MediaQuery.of(context).size.width * .8,
                    cornerRadius: 20.0,
                    activeBgColors: [
                      [AppColors().appWhiteColor],
                      [AppColors().appWhiteColor],
                    ],
                    activeFgColor: AppColors().appBarColor,
                    inactiveBgColor: AppColors().appBarColor,
                    inactiveFgColor: AppColors().backgroundColor,
                    initialLabelIndex: quranController.quranListIndex.value,
                    totalSwitches: 2,
                    labels: ["Surah", "Juz"],
                    radiusStyle: true,
                    onToggle: (quranListIndex) {
                      if (quranListIndex != null) {
                        quranController.changequranListIndex(
                          index: quranListIndex,
                        );
                      }
                    },
                  ),
                ),
                SizedBox(height: 16),

                // 📜 List of Surahs or Juz
                Expanded(
                  child: Obx(
                    () =>
                        quranController.quranListIndex.value == 0
                            ? SurahList()
                            : JuzList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
