import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_hadith_app/core/app_colors.dart';
import 'package:quran_hadith_app/quran/controller/audio_controller.dart';

class QuranAudioScreen extends StatelessWidget {
  final QuranAudioController controller = Get.put(QuranAudioController());
  final int? surahNumber;
  final int? juzNumber;
  final bool surah;
  QuranAudioScreen({
    super.key,
    this.surahNumber,
    this.juzNumber,
    required this.surah,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// **Surah Name & Reciter**
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Al-Fatiha",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors().appWhiteColor,
                  ),
                ),
                Text(
                  "Abdul Basit",
                  style: TextStyle(
                    fontSize: 17,
                    color: AppColors().appWhiteColor,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                /// **Play Button**
                Obx(
                  () => IconButton(
                    icon: Icon(
                      controller.isPlaying.value
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: AppColors().appWhiteColor,
                    ),
                    iconSize: 32,
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
                    iconSize: 28,
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
    //   );
  }
}
