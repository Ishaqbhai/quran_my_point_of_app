import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:quran_hadith_app/quran/controller/quran_controller.dart';

class QuranAudioController extends GetxController {
  final AudioPlayer player = AudioPlayer();
  var isPlaying = false.obs;
  var position = Duration.zero.obs;
  var duration = Duration.zero.obs;
  final QuranController quranController = Get.find();
  String audioUrl =
      //"https://server8.mp3quran.net/afs/001005.mp3";
      //"https://server8.mp3quran.net/afs/001.mp3"; // Example Surah
      "https://server8.mp3quran.net/afs/${1.toString().padLeft(3, '0')}.mp3";
  @override
  void onInit() {
    super.onInit();

    player.onPositionChanged.listen((Duration pos) {
      position.value = pos;
    });

    player.onDurationChanged.listen((Duration dur) {
      duration.value = dur;
    });

    player.onPlayerComplete.listen((_) {
      isPlaying.value = false;
      position.value = Duration.zero;
    });
  }

  Future<void> playAudioBySurah({required int surahNumber}) async {
    //String url = getVerseURL(1, 5);
    String url =
        "https://server8.mp3quran.net/afs/${surahNumber.toString().padLeft(3, '0')}.mp3";
    isPlaying.value = true;
    await player.play(UrlSource(url));
  }

  Future<void> playAudioByJuz({required int juzNumber}) async {
    // Adjust for zero-based indexing
    Map<String, dynamic> juzDataMap = QuranController.juzData[juzNumber - 1];
    List<int> surahNumberList = List<int>.from(juzDataMap["surahs"]);

    for (int i = 0; i < surahNumberList.length; i++) {
      String surahNumber = surahNumberList[i].toString().padLeft(3, '0');
      String url = "https://server8.mp3quran.net/afs/$surahNumber.mp3";
      await player.play(UrlSource(url)); // This plays one after another
      isPlaying.value = true;
    }
  }

  Future<void> pauseAudio() async {
    await player.pause();
    isPlaying.value = false;
  }

  Future<void> stopAudio() async {
    await player.stop();
    isPlaying.value = false;
    position.value = Duration.zero;
  }

  Future<void> seekAudio(Duration newPosition) async {
    await player.seek(newPosition);
  }

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }
}
