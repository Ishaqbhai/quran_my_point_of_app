import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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
  final downloadedFiles = <String, bool>{}.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void onInit() {
    super.onInit();
    fetchBooksFromFirebase();
    preloadDownloadedBooks();
  }

  File? selectedImage;

  Future<void> selectImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      selectedImage = File(result.files.single.path!);
    }
  }

  Future<void> preloadDownloadedBooks() async {
    final dir = await getApplicationDocumentsDirectory();
    for (var book in books) {
      final rawFileName = Uri.decodeFull(
        book.url.split('/').last.split('?').first,
      );
      // rawFileName: books/Alappuzha (a).pdf
      final fileName = rawFileName.split('/').last;
      // fileName: Alappuzha (a).pdf
      final file = File('${dir.path}/$fileName');
      if (await file.exists()) {
        downloadedFiles[fileName] = true;
      }
    }
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

  Future<void> downloadPDF(
    String url,
    String filename,
    BuildContext context,
  ) async {
    try {
      if (!filename.toLowerCase().endsWith('.pdf')) {
        filename += '.pdf';
      }

      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$filename');

      if (await file.exists()) {
        downloadedFiles[filename] = true;
        OpenFile.open(file.path);
      } else {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(
            // ignore: use_build_context_synchronously
            context,
          ).showSnackBar(SnackBar(content: Text('Downloading $filename...')));

          await file.writeAsBytes(response.bodyBytes);
          downloadedFiles[filename] = true;
          OpenFile.open(file.path);
        } else {
          Get.snackbar('Error', 'Failed to download file');
        }
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

    if (selectedFile != null) {
      final file = selectedFile!.files.single;
      if (!file.name.toLowerCase().endsWith('.pdf')) {
        Get.snackbar('Invalid File', 'Please select a valid PDF file.');
        selectedFile = null;
      }
    }
  }

  Future<void> uploadPDFToFirebase(String bookName) async {
    if (selectedFile == null || selectedFile!.files.single.path == null) return;

    isLoading.value = true;

    final filePath = selectedFile!.files.single.path!;
    final originalFileName = selectedFile!.files.single.name;
    final fileName =
        originalFileName.toLowerCase().endsWith('.pdf')
            ? originalFileName
            : '$originalFileName.pdf'; // Ensure .pdf extension

    final file = File(filePath);

    try {
      final ref = _storage.ref().child('books/$fileName');
      await ref.putFile(file);

      final url = await ref.getDownloadURL();

      // Image upload remains same
      String? imageUrl;
      if (selectedImage != null) {
        final imgRef = _storage.ref().child(
          'book_covers/${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
        await imgRef.putFile(selectedImage!);
        imageUrl = await imgRef.getDownloadURL();
      }

      final docRef = _firestore.collection('book_table').doc();
      await docRef.set({
        'id': docRef.id,
        'name': bookName,
        'url': url,
        'fileName': fileName, // Optional: to know the exact filename
        'coverUrl': imageUrl ?? '',
      });

      await fetchBooksFromFirebase();
      Get.snackbar('Success', 'Book uploaded to Firebase!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
