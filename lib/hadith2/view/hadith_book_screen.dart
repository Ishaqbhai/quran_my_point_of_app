import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hadith/classes.dart';
import 'package:quran_hadith_app/boarding/controller/home_controller.dart';
import 'package:quran_hadith_app/boarding/controller/loading_controller.dart';
import 'package:quran_hadith_app/boarding/view/home_screen.dart';
import 'package:quran_hadith_app/core/app_colors.dart';
import 'package:quran_hadith_app/hadith2/controller/hadith_controller.dart';
import 'package:quran_hadith_app/hadith2/view/hadith_detail_screen.dart';

class HadithBookScreen extends StatelessWidget {
  final HadithController controller = Get.put(HadithController());
  final HomeController homeController = Get.put(HomeController());
  final String title;
  HadithBookScreen({super.key, required this.title});
  final loadingController = Get.find<LoadingController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          onPressed: () {
            homeController.bottomNavIndex.value = 1;
            Get.to(HomeScreen());
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      itemCount: controller.hadithBooks.length,
                      itemBuilder: (context, index) {
                        final book = controller.hadithBooks[index];

                        // Extracting English title (fallback to Arabic if needed)
                        String bookTitle =
                            book.book
                                .firstWhere(
                                  (b) => b.lang == "en",
                                  orElse:
                                      () => BookData(
                                        lang: "unknown",
                                        name: "Unknown Book",
                                      ),
                                )
                                .name;
                        String bookTitleArabic =
                            book.book
                                .firstWhere(
                                  (b) => b.lang == "ar",
                                  orElse:
                                      () => BookData(
                                        lang: "غير معروف",
                                        name: "كتاب غير معروف",
                                      ),
                                )
                                .name;
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
                              bookTitle,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            // subtitle: Text("Book Number: ${book.bookNumber}"),
                            subtitle: Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                bookTitleArabic,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'TraditionalArabic',
                                ),
                              ),
                            ),

                            onTap: () {
                              // Navigate to book details
                              loadingController.showLoading();
                              controller.fetchHadithList(
                                bookIndex: index + 1,
                                noOfHadith: book.numberOfHadith,
                              );
                              loadingController.hideLoading();
                              Get.to(() => HadithDetailScreen());
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
          Obx(() {
            return loadingController.isLoading.value
                ? Container(
                  color: Colors.black54,
                  child: const Center(child: CircularProgressIndicator()),
                )
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
