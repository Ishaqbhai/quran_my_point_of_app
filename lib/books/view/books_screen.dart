import 'package:double_tap_to_exit/double_tap_to_exit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_hadith_app/Profile/controller/profile_controller.dart';
import 'package:quran_hadith_app/books/controller/book_controller.dart';
import 'package:quran_hadith_app/books/view/add_book_screeen.dart';
import 'package:quran_hadith_app/core/app_colors.dart';

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
                        ? CircularProgressIndicator()
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
                              final book = bookController.books[index];
                              return Stack(
                                children: [
                                  // Book background
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors().appBarColor,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors().appBarColor,
                                          blurRadius: 4,
                                          offset: Offset(2, 4),
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.all(12),
                                    child: Center(
                                      child: Text(
                                        book.name,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors().appWhiteColor,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 6,
                                    child: Visibility(
                                      visible:
                                          profileController.isLoggedIn.value,
                                      child: PopupMenuButton<String>(
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
                                  // Download button
                                  Positioned(
                                    bottom: 8,
                                    right: 8,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors().appWhiteColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.download_rounded,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          // Handle download here
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Downloading ${book.name}...',
                                              ),
                                            ),
                                          );
                                          bookController.downloadPDF(
                                            book.url,
                                            book.url.split('/').last,
                                          );
                                        },
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
