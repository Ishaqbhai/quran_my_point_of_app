import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_hadith_app/Profile/controller/profile_controller.dart';
import 'package:quran_hadith_app/dua/model/category_model.dart';
import 'package:quran_hadith_app/dua/model/dua_model.dart';
import 'package:quran_flutter/enums/quran_language.dart';

class DuaController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController tittleController = TextEditingController();
  final TextEditingController arabicController = TextEditingController();
  final TextEditingController englishController = TextEditingController();
  final TextEditingController tamilController = TextEditingController();
  final TextEditingController malayalamController = TextEditingController();
  final TextEditingController hindiController = TextEditingController();
  final TextEditingController uruduController = TextEditingController();
  var isLoading = false.obs;
  final RxString selectedCategory = ''.obs;
  final RxList<DuaModel> duaList = <DuaModel>[].obs;
  final RxList<DuaCategoryModel> categoryList = <DuaCategoryModel>[].obs;
  final ProfileController profileController = Get.put(ProfileController());
  RxString duaLanguage = "".obs;

  @override
  void onInit() {
    fetchCategories();
    fetchAllDuas();
    super.onInit();
  }

  Future<void> updateDua({
    required DuaModel updatedDua,
    required String docId,
    required String category,
  }) async {
    isLoading.value = true;
    try {
      await _firestore.collection('dua_table').doc(docId).update({
        'dua_arabic': arabicController.text.trim(),
        'dua_meaning': englishController.text.trim(),
        'meaning_tamil': tamilController.text.trim(),
        'meaning_urudu': uruduController.text.trim(),
        'meaning_malayalam': malayalamController.text.trim(),
        'category': updatedDua.category,
        'tittle': tittleController.text.trim(),
        'meaning_hindi': hindiController.text.trim(),
      });
      Get.back();
      Get.snackbar("Success", "Dua updated successfully!");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
      clear();
    }
  }

  Future<void> fetchDuasByCategory(String category) async {
    isLoading.value = true;
    try {
      final snapshot =
          await _firestore
              .collection('dua_table')
              .where('category', isEqualTo: category)
              .get();

      duaList.assignAll(
        snapshot.docs
            .map((doc) => DuaModel.fromJson(doc.data()..['id'] = doc.id))
            .toList(),
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch duas for $category");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteDua(String docId) async {
    try {
      await _firestore.collection('dua_table').doc(docId).delete();
      Get.snackbar("Success", "Dua deleted successfully!");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> fetchAllDuas() async {
    try {
      final snapshot = await _firestore.collection('dua_table').get();
      duaList.value =
          snapshot.docs
              .map((doc) => DuaModel.fromJson(doc.data()..['id'] = doc.id))
              .toList();
    } catch (e) {
      // optional: handle error
    }
  }

  Future<void> saveDua() async {
    isLoading.value = true;
    try {
      final docRef =
          _firestore.collection('dua_table').doc(); // Step 1: Get a new doc ref
      final String docId = docRef.id; // Step 2: Get the ID
      await docRef.set({
        'id': docId,
        'dua_arabic': arabicController.text.trim(),
        'dua_meaning': englishController.text.trim(),
        'meaning_tamil': tamilController.text.trim(),
        'meaning_urudu': uruduController.text.trim(),
        'meaning_malayalam': malayalamController.text.trim(),
        'category': selectedCategory.value, // should be category ID, not name
        'tittle': tittleController.text.trim(),
        'meaning_hindi': hindiController.text.trim(),
      });

      Get.back();
      Get.snackbar("Success", "Dua added successfully!");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
    clear();
  }

  Future<void> createDuaCategory(String category) async {
    try {
      final docRef = _firestore.collection('category_table').doc();
      final String docId = docRef.id;

      await docRef.set({'id': docId, 'category': category});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchCategories() async {
    try {
      final snapshot = await _firestore.collection('category_table').get();
      categoryList.value =
          snapshot.docs
              .map(
                (doc) => DuaCategoryModel.fromJson(doc.data()..['id'] = doc.id),
              )
              .toList();
    } catch (e) {
      // handle error
      rethrow;
    }
  }

  Future<void> insertDuaCategory({required String category}) async {
    try {
      await _firestore.collection('category_table').add({
        'category': category,
        'created_at': FieldValue.serverTimestamp(),
      });
      Get.snackbar("Success", "✅ Category inserted successfully.");
      fetchCategories();
    } catch (e) {
      Get.snackbar("Error", "❌ Error inserting category: $e");
    }
  }

  Future<void> updateDuaCategory({
    required String docId,
    required String newCategory,
  }) async {
    try {
      await _firestore.collection('category_table').doc(docId).update({
        'category': newCategory,
      });

      Get.snackbar("Success", "✅ Category updated successfully.");
      fetchCategories();
    } catch (e) {
      Get.snackbar("Error", "❌ Error updating category: $e");
    }
  }

  Future<void> deleteDuaCategory(String docId) async {
    try {
      final duaDocs =
          await _firestore
              .collection('dua_table')
              .where('category', isEqualTo: docId)
              .get();

      for (var doc in duaDocs.docs) {
        await doc.reference.delete();
      }

      await _firestore.collection('category_table').doc(docId).delete();

      Get.snackbar(
        "Success",
        "✅ Category and associated Duas deleted successfully.",
      );
      fetchCategories();
    } catch (e) {
      Get.snackbar("Error", "❌ Error deleting category: $e");
    }
  }

  Future<void> duaLanguages(DuaModel dua) async {
    switch (profileController.selectedLanguage.value) {
      case QuranLanguage.hindi:
        duaLanguage.value = dua.hindi;
        break;
      case QuranLanguage.malayalam:
        duaLanguage.value = dua.malayalam;
        break;
      case QuranLanguage.tamil:
        duaLanguage.value = dua.tamil;
        break;
      case QuranLanguage.urdu:
        duaLanguage.value = dua.urudu;
        break;
      default:
        duaLanguage.value = dua.english;
    }
    if (duaLanguage.value == "") {
      duaLanguage.value = dua.english;
    }
  }

  clear() {
    tittleController.clear();
    arabicController.clear();
    englishController.clear();
    tamilController.clear();
    malayalamController.clear();
    hindiController.clear();
    uruduController.clear();
  }
}
