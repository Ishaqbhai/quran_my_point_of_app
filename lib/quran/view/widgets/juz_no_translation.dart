// import 'package:flutter/material.dart';
// import 'package:quran_flutter/quran.dart';
// import 'package:quran/quran.dart' as Quran;
// import 'package:quran_hadith_app/core/app_colors.dart';

// class JuzNoTranslation extends StatelessWidget {
//   const JuzNoTranslation({super.key, required this.juzNumber});
//   final int juzNumber;

//   @override
//   Widget build(BuildContext context) {
//     // Get the full Surah text as one string

//     // for (int i = 1; i <= totalVerses; i++) {
//     //   surahText +=
//     //       "${Quran.getVerse(surahNumber, i)}${Quran.getVerseEndSymbol(i)}"; // Add verse end symbol
//     // }

//     Map<int, List<int>> surahAndVerses = Quran.getSurahAndVersesFromJuz(
//       juzNumber,
//     );
//     return Container(
//       height: 500,
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child:
//         // : ListView.builder(
//                       //   physics: NeverScrollableScrollPhysics(),
//                       //   shrinkWrap: true,
//                       //   itemCount: surahsInJuz[index]['ayahCount'],
//                       //   itemBuilder: (context, i) {
//                       //     final verse = quranController.getVersesOfSurah(
//                       //       surahNumber: surahNumbers[index],
//                       //     );
//                       //     final translation = quranController
//                       //         .getTranslationOfSurah(
//                       //           surahNumber: surahNumbers[index],
//                       //         );
//                       //     return verseTile(
//                       //       "${verse[i].text}",
//                       //       "${index + 1}. ${translation[i].text}",
//                       //     );
//                       //   },
//         //  ListView.builder(
//         //   itemCount: surahAndVerses.length,
//         //   itemBuilder: (context, index) {
//         //     // Get the current Surah and its list of Ayahs
//         //     int surahNumber = surahAndVerses.keys.elementAt(index);
//         //     List<int> ayahNumbers = surahAndVerses[surahNumber]!;

//         //     // Generate the full text for the Surah
//         //     String surahText = " ";
//         //     for (int ayahNumber in ayahNumbers) {
//         //       print("...............................1....................");
//         //       print(ayahNumber);
//         //       print(ayahNumbers);
//         //       print(surahNumber);
//         //       surahText +=
//         //           "${Quran.getVerse(surahNumber, ayahNumber)} ${Quran.getVerseEndSymbol(ayahNumber)} ";
//         //     }

//         //     return Card(
//         //       color: AppColors().appWhiteColor,
//         //       margin: const EdgeInsets.symmetric(vertical: 5),
//         //       elevation: 3,
//         //       child: ExpansionTile(
//         //         title: Text(
//         //           surahText,
//         //           //   "Surah ${Quran.getSurahNameEnglish(surahNumber)}",
//         //           style: const TextStyle(
//         //             fontSize: 16,
//         //             fontWeight: FontWeight.bold,
//         //           ),
//         //         ),
//         //         subtitle: Text(
//         //           "Total Ayahs: ${ayahNumbers.length}",
//         //           style: const TextStyle(fontSize: 14),
//         //         ),
//         //         // trailing: Text(
//         //         //   Quran.getSurahName(surahNumber),
//         //         //   style: const TextStyle(
//         //         //     fontSize: 20,
//         //         //     fontFamily: 'TraditionalArabic',
//         //         //   ),
//         //         // ),
//         //         children: [
//         //           Padding(
//         //             padding: const EdgeInsets.all(10.0),
//         //             child: Text(
//         //               surahText,
//         //               style: const TextStyle(
//         //                 fontSize: 18,
//         //                 fontFamily: 'AmiriQuran', // Arabic font
//         //                 height: 2.0,
//         //               ),
//         //               textAlign: TextAlign.right,
//         //             ),
//         //           ),
//         //         ],
//         //       ),
//         //     );
//         //   },
//         // ),
//       ),
//     );
//   }
// }

//     //);
//     // return SingleChildScrollView(
//     //   child: Card(
//     //     color: AppColors().appWhiteColor,
//     //     margin: const EdgeInsets.symmetric(vertical: 5),
//     //     elevation: 3,
//     //     child: Padding(
//     //       padding: const EdgeInsets.all(16.0),
//     //       child: Text(
//     //         surahText,
//     //         style: const TextStyle(
//     //           fontSize: 20,
//     //           fontFamily: 'AmiriQuran', // Arabic font
//     //           height: 2.0, // Better readability
//     //         ),
//     //         textAlign: TextAlign.right,
//     //       ),
//     //     ),
//     //   ),
//     // );
