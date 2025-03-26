import 'package:flutter/material.dart';
import 'package:quran_hadith_app/core/app_colors.dart';
import 'package:quran_hadith_app/quran/view/surah_pages_of_quran.dart';

class SurahDetailScreen extends StatelessWidget {
  final int surahNumber;

  const SurahDetailScreen({super.key, required this.surahNumber});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Card(
              color: AppColors().appWhiteColor,
              margin: const EdgeInsets.only(top: 5),
              elevation: 3,
              child: SurahPagesOfQuran(surahNo: surahNumber),
            ),
          ),
        ),
      ],
    );
  }
}
