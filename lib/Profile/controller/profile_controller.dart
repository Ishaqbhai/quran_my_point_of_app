import 'package:get/get.dart';
import 'package:quran_flutter/enums/quran_language.dart';

class ProfileController extends GetxController {
  RxString language = "QuranLanguage.english".obs;
   var selectedLanguage = QuranLanguage.english.obs;

  // Method to update the selected language
  void updateLanguage(QuranLanguage language) {
    selectedLanguage.value = language;
  }
  changeLanguage({required String lang}) {
    language.value = lang;
  }
}
