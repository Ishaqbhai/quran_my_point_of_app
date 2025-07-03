import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_hadith_app/core/app_colors.dart';
import 'package:quran_hadith_app/quran/controller/audio_controller.dart';

class QuranAudioScreen extends StatelessWidget {
  final QuranAudioController controller = Get.put(QuranAudioController());
  final int? surahNumber;
  final int? juzNumber;
  final bool surah;
  final String? surahName;
  QuranAudioScreen({
    super.key,
    this.surahNumber,
    this.juzNumber,
    required this.surah,
    this.surahName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors().bookmarkColor, // Match screen background color
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            spreadRadius: 1,
            offset: Offset(0, -2), // Floating effect
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // **Surah Name & Reciter**
            SizedBox(
              width: MediaQuery.of(context).size.width * .63,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  surah
                      ? Text(
                        surahName!,
                        //  "Al-Fatiha",
                        style: TextStyle(
                          fontSize: 17,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          color: AppColors().appWhiteColor,
                        ),
                      )
                      : Text(
                        "Juz $juzNumber",
                        //  "Al-Fatiha",
                        style: TextStyle(
                          fontSize: 17,
                          overflow: TextOverflow.ellipsis,
                          fontWeight: FontWeight.bold,
                          color: AppColors().appWhiteColor,
                        ),
                      ),

                  Text(
                    "Abdul Basit",
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors().appWhiteColor,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                /// **Play Button**
                Obx(
                  () => IconButton(
                    splashRadius: 1,
                    icon: Icon(
                      controller.isPlaying.value
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: AppColors().appWhiteColor,
                    ),
                    iconSize: 30,
                    onPressed: () async {
                      controller.isPlaying.value
                          ? controller.pauseAudio()
                          : surah
                          ? await controller.playAudioBySurah(
                            surahNumber: surahNumber!,
                          )
                          : controller.playAudioByJuz(juzNumber: juzNumber!);
                    },
                  ),
                ),

                // **Stop Button**
                Obx(
                  () => IconButton(
                    icon: Icon(Icons.stop, color: AppColors().appWhiteColor),
                    iconSize: 26,
                    splashRadius: 1,
                    onPressed:
                        controller.isPlaying.value
                            ? controller.stopAudio
                            : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
