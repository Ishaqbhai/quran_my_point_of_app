import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hadith/classes.dart';
import 'package:hadith/hadith.dart';
import 'package:html/parser.dart';
import 'package:quran_flutter/enums/quran_language.dart';
import 'package:quran_hadith_app/Profile/controller/profile_controller.dart';
import 'package:quran_hadith_app/hadith2/model/hadith_item.dart';
import 'package:translator/translator.dart';

class HadithController extends GetxController {
  RxList<Book> hadithBooks = <Book>[].obs;
  RxList collection = <Collection>[].obs;
  RxBool isLoading = true.obs;
  RxString hadithTitle = ''.obs;
  RxString hadithArabicText = ''.obs;
  RxString hadithTranslation = ''.obs;
  RxList hadithList = <HadithItem>[].obs;
  String collectionName = "";
  int hadithNo = 0;
  final TextEditingController searchHadithController = TextEditingController();
  late Collections collectionEnum;
  int bookNumber = 0;
  int totalNumberOfHadith = 0;
  final ProfileController profileController = Get.put(ProfileController());
  RxString hadithLanguage = "".obs;
  final translator = GoogleTranslator();

  RxList<Book> allHadithBooks = <Book>[].obs;

  @override
  void onInit() {
    fetchHadithCollections();
    super.onInit();
  }

  @override
  void dispose() {
    hadithList.clear();
    searchHadithController.clear();
    super.dispose();
  }

  clearHadithList() {
    hadithList.clear();
  }

  void fetchHadithBooks({required String collection}) async {
    try {
      isLoading(true);
      collectionName = collection;
      collectionEnum = Collections.values.firstWhere(
        (e) => e.toString().split('.').last == collectionName,
      );

      final books = getBooks(collectionEnum);
      allHadithBooks.value = books;
      hadithBooks.value = books; // display all initially
    } catch (e) {
      Get.snackbar("Error", "Error fetching books: $e");
    } finally {
      isLoading(false);
    }
  }

  void filterBooks(String query) {
    final lowerQuery = query.toLowerCase();
    isLoading(true);
    if (lowerQuery.isEmpty || lowerQuery == "") {
      hadithBooks = allHadithBooks;
      isLoading(false);
    } else {
      hadithBooks.value =
          allHadithBooks.where((book) {
            final englishTitle =
                book.book
                    .firstWhere(
                      (b) => b.lang == "en",
                      orElse: () => BookData(lang: "", name: ""),
                    )
                    .name
                    .toLowerCase();

            final arabicTitle =
                book.book
                    .firstWhere(
                      (b) => b.lang == "ar",
                      orElse: () => BookData(lang: "", name: ""),
                    )
                    .name;

            isLoading(false);
            return englishTitle.contains(lowerQuery) ||
                arabicTitle.contains(lowerQuery);
          }).toList();
    }
  }

  void fetchHadithCollections() async {
    try {
      isLoading(true);
      collection.value = getCollections();
    } catch (e) {
      Get.snackbar("Error", "Error fetching hadith books: $e");
    } finally {
      isLoading(false);
    }
  }

  void fetchHadithList({required bookIndex, required noOfHadith}) async {
    try {
      isLoading.value = true;
      clearHadithList();
      bookNumber = bookIndex;
      totalNumberOfHadith = noOfHadith;
      // Example: Loop through Hadiths, assume max range is 10 for demo
      for (int i = 1; i <= noOfHadith; i++) {
        // Fetch details for each Hadith
        await fetchHadithDetails(
          collection: collectionEnum,
          hadithNumber: i,
          bookNumber: bookIndex,
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Error fetching hadith list: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchHadithDetails({
    required Collections collection,
    required int hadithNumber,
    required int bookNumber,
  }) async {
    try {
      Hadith hadith = getHadith(collection, bookNumber, hadithNumber);
      // Fetch Arabic and English Hadith
      HadithData arabicHadith = getHadithData(
        collection,
        bookNumber,
        hadithNumber,
        Languages.ar,
      );

      HadithData englishHadith = getHadithData(
        collection,
        bookNumber,
        hadithNumber,
        Languages.en,
      );
      // Process Hadith data
      String cleanedArabic = arabicHadith.body.replaceAll(
        RegExp(r'\[.*?\]'),
        '',
      );
      var arabicDocument = parse(cleanedArabic);
      String arabicText = arabicDocument.body?.text ?? 'Arabic not available.';

      String cleanedEnglish = englishHadith.body.replaceAll(
        RegExp(r'\[.*?\]'),
        '',
      );
      var englishDocument = parse(cleanedEnglish);
      String englishText =
          englishDocument.body?.text ?? 'Translation not available.';

      // Add to the list
      hadithList.add(
        HadithItem(
          title: hadith.hadith.first.chapterTitle,
          arabic: arabicText,
          english: englishText,
        ),
      );
    } catch (e) {
      Get.snackbar("Error", "Error fetching hadith details: $e");
    }
  }

  void fetchHadithDetails2() async {
    try {
      // Replace with actual API or package method
      Hadith hadith = getHadith(Collections.bukhari, 1, 1);
      HadithData arabicHadith = getHadithData(
        Collections.bukhari,
        1,
        1,
        Languages.ar,
      );

      // Assuming the first HadithData is the one we need
      if (hadith.hadith.isNotEmpty) {
        HadithData hadithData = hadith.hadith.first;
        hadithTitle.value = hadithData.chapterTitle;
        if (arabicHadith.body.isNotEmpty) {
          String cleanedText = arabicHadith.body.replaceAll(
            RegExp(r'\[.*?\]'),
            '',
          );
          var document = parse(cleanedText);
          hadithArabicText.value =
              document.body?.text ?? 'Arabic text not available.';
        } else {
          hadithArabicText.value = 'Arabic text not available.';
        }

        HadithData englishHadith = getHadithData(
          Collections.bukhari,
          1,
          1,
          Languages.en,
        );
        if (englishHadith.body.isNotEmpty) {
          // Parse HTML to clean any tags
          var document = parse(englishHadith.body);
          hadithTranslation.value =
              document.body?.text ?? 'Translation not available.';
        } else {
          hadithTranslation.value = 'Translation not available.';
        }
      }
    } catch (e) {
      // Handle errors
      hadithTitle.value = 'Error fetching Hadith';
      hadithArabicText.value = '';
      hadithTranslation.value = '';
    }
  }

  fetchHadithLanguage({required String hadithMeaning}) async {
    switch (profileController.selectedLanguage.value) {
      case QuranLanguage.hindi:
        hadithLanguage.value =
            (await translator.translate(
              hadithMeaning,
              from: 'en',
              to: 'hi', // Hindi language code
            )).text;
        break;

      case QuranLanguage.malayalam:
        hadithLanguage.value =
            (await translator.translate(
              hadithMeaning,
              from: 'en',
              to: 'ml', // Malayalam language code
            )).text;
        break;

      case QuranLanguage.tamil:
        hadithLanguage.value =
            (await translator.translate(
              hadithMeaning,
              from: 'en',
              to: 'ta', // Tamil language code
            )).text;
        break;

      case QuranLanguage.urdu:
        hadithLanguage.value =
            (await translator.translate(
              hadithMeaning,
              from: 'en',
              to: 'ur', // Urdu language code
            )).text;
        break;

      default:
        hadithLanguage.value =
            hadithMeaning; // Default: show English if no match
    }
  }
}
