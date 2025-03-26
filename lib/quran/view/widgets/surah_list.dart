import 'package:flutter/material.dart';
import 'package:flutter_quran/flutter_quran.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_flutter/models/surah.dart';
import 'package:quran_flutter/quran.dart';
import 'package:quran_hadith_app/boarding/controller/loading_controller.dart';
import 'package:quran_hadith_app/core/app_colors.dart';
import 'package:quran_hadith_app/quran/controller/quran_controller.dart';
import 'package:quran_hadith_app/quran/controller/surah_search_controller.dart';

class SurahList extends StatelessWidget {
  SurahList({super.key});

  final SurahSearchController searchController =
      Get.find<SurahSearchController>();
  final QuranController quranController = Get.find<QuranController>();
  final loadingController = Get.find<LoadingController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(() {
          final bool isSearching = searchController.searchText.isNotEmpty;
          final List<Surah> surahs =
              isSearching
                  ? searchController.filteredSurahs
                  : List.generate(
                    Quran.surahCount,
                    (index) => Quran.getSurah(index + 1),
                  );

          return ListView.builder(
            itemCount: surahs.length,
            itemBuilder: (context, index) {
              final Surah surah = surahs[index];
              final int surahNumber = surah.number;
              final String surahName = surah.name;
              final String surahNameEnglish = surah.nameEnglish;
              final String surahMeaning = surah.meaning;
              final int totalVerses = Quran.getTotalVersesInSurah(surahNumber);

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors().backgroundColor,
                    child: Text(
                      surahNumber.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    surahNameEnglish,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        surahMeaning,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.book, size: 16, color: Colors.grey),
                          const SizedBox(width: 5),
                          Text(
                            "$totalVerses Ayat",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Text(
                    surahName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'TraditionalArabic',
                    ),
                  ),
                  onTap: () async {
                    loadingController.showLoading();
                    await Future.delayed(const Duration(seconds: 5));
                    quranController.getTotalVersesOfSurah(
                      surahNumber: surahNumber,
                    );
                    await quranController.getPageNoBySurah(
                      surahNumber: surahNumber,
                    );
                    quranController.getSurahDetails(surahNo: surahNumber);
                    FlutterQuran().navigateToSurah(surahNumber);
                    Get.toNamed('/surah_screen', arguments: surahNumber);
                    loadingController.hideLoading();
                  },
                ),
              );
            },
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
    );
  }
}
