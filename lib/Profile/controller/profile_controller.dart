
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:quran_flutter/enums/quran_language.dart';

class ProfileController extends GetxController {
  RxString language = "QuranLanguage.english".obs;

  RxBool isLoggedIn = false.obs;

  late Rx<QuranLanguage> selectedLanguage;

  @override
  void onInit() {
    selectedLanguage = QuranLanguage.english.obs;
    isLoggedIn.value = isLogged(); // or however you initialize
    super.onInit();
  }

  final List<QuranLanguage> quranLanguages = [
    QuranLanguage.english,
    QuranLanguage.hindi,
    QuranLanguage.malayalam,
    QuranLanguage.tamil,
    QuranLanguage.urdu,
  ];

  changeLanguage({required String lang}) {
    language.value = lang;
  }

  final box = Hive.box('AuthorLogin');

  void login({required String userName, required String password}) {
    box.put('UserName', userName);
    box.put('Password', password);
    box.put('isLoggedIn', true);
    isLoggedIn.value = isLogged();
  }

  bool isLogged() {
    return box.get('isLoggedIn', defaultValue: false);
  }

  void logout() {
    box.clear();
    box.put('isLoggedIn', false);
    isLoggedIn.value = isLogged();
  }
}
