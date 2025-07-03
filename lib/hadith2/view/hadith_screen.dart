import 'package:double_tap_to_exit/double_tap_to_exit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hadith/classes.dart';
import 'package:quran_hadith_app/core/app_colors.dart';
import 'package:quran_hadith_app/hadith2/controller/hadith_controller.dart';
import 'package:quran_hadith_app/hadith2/view/hadith_book_screen.dart';

class HadithScreen extends StatelessWidget {
  final HadithController controller = Get.put(HadithController());

  HadithScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DoubleTapToExit(
      child: PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(leading: SizedBox.shrink(), title: Text("Hadith")),
          body: Column(
            children: [
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      itemCount: controller.collection.length,
                      itemBuilder: (context, index) {
                        Collection book = controller.collection[index];

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 3,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors().backgroundColor,
                              child: Text(
                                "${index + 1}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            title: Text(
                              book.collection[0].title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hadiths: ${book.totalHadith}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    book.collection[1].title,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'TraditionalArabic',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              controller.fetchHadithBooks(
                                collection: book.name,
                              );
                              Get.to(
                                () => HadithBookScreen(
                                  title: book.collection[0].title,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
