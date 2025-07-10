import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_hadith_app/boarding/controller/home_controller.dart';
import 'package:quran_hadith_app/boarding/view/home_screen.dart';
import 'package:quran_hadith_app/books/controller/book_controller.dart';
import 'package:quran_hadith_app/core/app_colors.dart';

class AddBookScreeen extends StatelessWidget {
  AddBookScreeen({super.key});
  final BookController bookController = Get.put(BookController());
  final TextEditingController nameController = TextEditingController();
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Book")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors().appBarColor,
              borderRadius: BorderRadius.circular(10),
            ),

            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Obx(() {
                return ListView(
                  shrinkWrap: true,

                  children: [
                    SizedBox(height: 10),
                    Text("Enter the Book Name"),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: "Book Name",
                        prefixIcon: Icon(
                          Icons.menu_book_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    //......................................
                    Text("Select Cover Image"),
                    bookController.selectedImage != null
                        ? Image.file(
                          bookController.selectedImage!,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                        : SizedBox(),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await bookController.selectImage();
                      },
                      icon: Icon(Icons.image),
                      label: Text("Pick Cover Image"),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Select PDF"),
                        bookController.isLoading.value
                            ? CircularProgressIndicator()
                            : IconButton(
                              onPressed: () async {
                                String bookName = nameController.text.trim();
                                if (bookName.isEmpty) {
                                  Get.snackbar(
                                    'Error',
                                    'Please enter book name first.',
                                  );
                                } else {
                                  await bookController.selectFileToUpload();
                                  //bookController.uploadPDF(bookName);
                                  // await bookController.uploadPDFToSupabase(
                                  //   bookName,
                                  // );
                                }
                              },
                              icon: Icon(
                                Icons.upload_file_outlined,
                                color: AppColors().appWhiteColor,
                              ),
                            ),
                      ],
                    ),
                    if (bookController.pdfUrl.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          "Uploaded PDF URL:\n${bookController.pdfUrl.value}",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    if (bookController.isLoading.value)
                      Center(child: CircularProgressIndicator()),
                    SizedBox(height: 10),

                    /// 🔘 Save Button
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          String bookName = nameController.text.trim();
                          await bookController.uploadPDFToFirebase(bookName);

                          homeController.changeBottomNavIndex(index: 3);
                          Get.off(HomeScreen());
                        },
                        icon: Icon(Icons.save),
                        label: Text("Upload"),
                      ),
                    ),

                    if (bookController.isLoading.value)
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
