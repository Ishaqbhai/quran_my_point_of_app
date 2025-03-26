import 'package:flutter/material.dart';
import 'package:flutter_quran/flutter_quran.dart';
import 'package:get/get.dart';
import 'package:quran_hadith_app/boarding/controller/loading_controller.dart';
import 'package:quran_hadith_app/core/app_colors.dart';
import 'package:quran_hadith_app/quran/controller/quran_controller.dart';
import 'package:quran_hadith_app/quran/controller/surah_search_controller.dart'; // Import flutter_quran

class JuzList extends StatelessWidget {
  JuzList({super.key});

  final QuranController quranController = Get.find<QuranController>();
  final SurahSearchController searchController = Get.put(
    SurahSearchController(),
  );
  final loadingController = Get.find<LoadingController>();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 30,
      itemBuilder: (context, index) {
        var juz = QuranController.juzData[index];
        int juzNumber = juz['juz'];
        List<int> surahNumbers = juz["surahs"];
        // List<JuzSurahVerses> juzNumbers = Quran.getSurahVersesInJuzAsList(
        //   juzNumber,
        // );

        final surahDetails = quranController.getSurahDetailsInJuz(
          juzNumber: juzNumber,
          surahNumbers: surahNumbers,
        );
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 3,
          margin: EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors().backgroundColor,
              child: Text(
                juzNumber.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
              "Juz $juzNumber",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  surahDetails.map((detail) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Row(
                        children: [
                          Text(
                            " ${detail['surahName']}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            " ${detail['ayahCount']} Ayat",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            ),

            onTap: () async {
              loadingController.showLoading();
              // quranController.getAythJuzNoTranslation(surahNo: ,ayahCount: );
              // Navigate to Juz details page
              //    quranController.getAyathByPge();
              await Future.delayed(const Duration(seconds: 5));
              // quranController.getPageNoByjuz(
              //   juzNumber: juzNumber,
              //   surahNumber: surahNumbers[0],
              // );
              await quranController.getNoOfVersesInJuz(
                juzNumber: juzNumber,
                surahNumber: surahNumbers[0],
              );
              FlutterQuran().navigateToJozz(juzNumber);
              searchController.j.value = 0;
              Get.toNamed('/juz_screen', arguments: juzNumber);
              loadingController.hideLoading();
            },
          ),
        );
      },
    );
  }
}
