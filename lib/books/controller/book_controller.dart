
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quran_hadith_app/books/model/books_model.dart';

class BookController extends GetxController {
  var pdfUrl = ''.obs;
  var isLoading = false.obs;
  var books = <BooksModel>[].obs;
  FilePickerResult? selectedFile;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void onInit() {
    super.onInit();
    fetchBooksFromFirebase();
  }

  Future<void> fetchBooksFromFirebase() async {
    isLoading.value = true;
    final snapshot = await _firestore.collection('book_table').get();
    books.value =
        snapshot.docs
            .map((doc) => BooksModel.fromMap(doc.data()..['id'] = doc.id))
            .toList();
    isLoading.value = false;
  }

  Future<void> downloadPDF(String url, String filename) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/$filename');
        await file.writeAsBytes(bytes);
        Get.snackbar('Downloaded', 'File saved to ${file.path}');
        OpenFile.open(file.path);
      } else {
        Get.snackbar('Error', 'Failed to download file');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> updateBookName(String docId, String newName) async {
    try {
      await _firestore.collection('book_table').doc(docId).update({
        'name': newName,
      });
    
      await fetchBooksFromFirebase();
     
      Get.snackbar('Success', 'Book name updated!');
    
    } catch (e) {
    
      Get.snackbar('Error', 'Failed to update book: $e');
    }
  }

  Future<void> deleteBook({
    required String docId,
    required String fileUrl,
  }) async {
    try {
      isLoading.value = true;
      
      // Delete from Storage
      final ref = _storage.refFromURL(fileUrl);
    
      await ref.delete();
    
      // Delete from Firestore
      await _firestore.collection('book_table').doc(docId).delete();
    
      await fetchBooksFromFirebase();
     
      Get.snackbar('Deleted', 'Book and PDF deleted successfully!');
    } catch (e) {
     
      Get.snackbar('Error', 'Failed to delete: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectFileToUpload() async {
    selectedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
  }

  Future<void> uploadPDFToFirebase(String bookName) async {
    if (selectedFile == null || selectedFile!.files.single.path == null) return;

    isLoading.value = true;
    final filePath = selectedFile!.files.single.path!;
    final fileName = selectedFile!.files.single.name;
    final file = File(filePath);

    try {
      // Upload to Firebase Storage
      final ref = _storage.ref().child('books/$fileName');

      await ref.putFile(file);

      final url = await ref.getDownloadURL();

      // Save to Firestore
      final docRef = _firestore.collection('book_table').doc();

      await docRef.set({'id': docRef.id, 'name': bookName, 'url': url});
     

      await fetchBooksFromFirebase();
     
      Get.snackbar('Success', 'Book uploaded to Firebase!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
