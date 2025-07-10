import 'package:double_tap_to_exit/double_tap_to_exit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_hadith_app/Profile/controller/profile_controller.dart';
import 'package:quran_hadith_app/books/controller/book_controller.dart';
import 'package:quran_hadith_app/books/view/add_book_screeen.dart';
import 'package:quran_hadith_app/core/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BooksScreen extends StatelessWidget {
  BooksScreen({super.key});
  final BookController bookController = Get.put(BookController());
  final ProfileController profileController = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return DoubleTapToExit(
      child: PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(leading: SizedBox.shrink(), title: Text("Books")),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 500,
                  child: Obx(() {
                    return bookController.books.isEmpty
                        ? Text("No books in the collection.")
                        : bookController.isLoading.value
                        ? Center(
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator(),
                          ),
                        )
                        : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
                            itemCount: bookController.books.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, // Two books per row
                                  childAspectRatio:
                                      0.7, // Make it look more like a book shape
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),

                            itemBuilder: (context, index) {
                              bookController.preloadDownloadedBooks();
                              final book = bookController.books[index];
                              final rawFileName = Uri.decodeFull(
                                book.url.split('/').last.split('?').first,
                              );
                              // rawFileName: books/Alappuzha (a).pdf
                              final fileName = rawFileName.split('/').last;
                              // fileName: Alappuzha (a).pdf
                              return Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 4,
                                          offset: Offset(2, 4),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 4,
                                                  offset: Offset(2, 4),
                                                ),
                                              ],
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Stack(
                                                children: [
                                                  Positioned.fill(
                                                    child:
                                                        book.coverUrl.isNotEmpty
                                                            ? CachedNetworkImage(
                                                              imageUrl:
                                                                  book.coverUrl,
                                                              fit: BoxFit.cover,
                                                              placeholder:
                                                                  (
                                                                    context,
                                                                    url,
                                                                  ) => Center(
                                                                    child: Container(
                                                                      color:
                                                                          AppColors()
                                                                              .appBarColor,
                                                                    ),
                                                                  ),
                                                              errorWidget:
                                                                  (
                                                                    context,
                                                                    url,
                                                                    error,
                                                                  ) => Container(
                                                                    color:
                                                                        AppColors()
                                                                            .appBarColor,
                                                                  ),
                                                            )
                                                            : Container(
                                                              color:
                                                                  AppColors()
                                                                      .appBarColor,
                                                            ),
                                                  ),
                                                  Positioned.fill(
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      color: Color.fromRGBO(
                                                        0,
                                                        0,
                                                        0,
                                                        0.4,
                                                      ),
                                                      // color: Colors.black
                                                      //     .withOpacity(0.4),
                                                      child: Text(
                                                        book.name,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                        maxLines: 2,
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // ),
                                          Obx(() {
                                            final isDownloaded =
                                                bookController
                                                    .downloadedFiles[fileName] ??
                                                false;
                                            return Positioned(
                                              bottom: 8,
                                              right: 8,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: IconButton(
                                                  icon: Icon(
                                                    isDownloaded
                                                        ? Icons.open_in_new
                                                        : Icons.download,
                                                    color: Colors.black,
                                                  ),
                                                  onPressed: () {
                                                    bookController.downloadPDF(
                                                      book.url,
                                                      fileName,
                                                      context,
                                                    );
                                                  },
                                                ),
                                              ),
                                            );
                                          }),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // Popup menu (edit/delete)
                                  Positioned(
                                    top: 1,
                                    right: 1,
                                    child: Visibility(
                                      visible:
                                          profileController.isLoggedIn.value,
                                      child: PopupMenuButton<String>(
                                        iconColor: Colors.white,

                                        onSelected: (value) {
                                          if (value == 'edit') {
                                            _showEditDialog(
                                              context,
                                              book.id,
                                              book.name,
                                            );
                                          } else if (value == 'delete') {
                                            bookController.deleteBook(
                                              docId: book.id,
                                              fileUrl: book.url,
                                            );
                                          }
                                        },
                                        itemBuilder:
                                            (context) => [
                                              const PopupMenuItem(
                                                value: 'edit',
                                                child: Text('Edit'),
                                              ),
                                              const PopupMenuItem(
                                                value: 'delete',
                                                child: Text('Delete'),
                                              ),
                                            ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                  }),
                ),
              ],
            ),
          ),
          floatingActionButton: Visibility(
            visible: profileController.isLoggedIn.value,
            child: FloatingActionButton(
              onPressed: () {
                Get.to(() => AddBookScreeen());
              },
              child: Text("+Book"),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, String id, String oldName) {
    final controller = TextEditingController(text: oldName);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Edit Book Name'),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: "Enter new name"),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  final newName = controller.text.trim();
                  if (newName.isNotEmpty) {
                    bookController.updateBookName(id, newName);
                  }
                  Navigator.of(context).pop();
                },
                child: Text('Update'),
              ),
            ],
          ),
    );
  }
}
