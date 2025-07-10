import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_hadith_app/Profile/controller/profile_controller.dart';
import 'package:quran_hadith_app/bookmarks/controller/bookmark_controller.dart';
import 'package:quran_hadith_app/core/app_colors.dart';
import 'package:quran_hadith_app/dua/controller/dua_controller.dart';
import '../model/dua_model.dart';

class DuaDetails extends StatelessWidget {
  DuaDetails({super.key, required this.categoryName});
  final DuaController duaController = Get.put(DuaController());
  final ProfileController profileController = Get.put(ProfileController());
  final BookmarkController bookmarkController = Get.put(BookmarkController());
  final String categoryName;
  @override
  Widget build(BuildContext context) {
    duaController.fetchDuasByCategory(categoryName);
    return Scaffold(
      appBar: AppBar(leading: SizedBox.shrink(), title: Text("Duas")),
      body: Obx(() {
        return duaController.duaList.isEmpty
            ? Text("Your dua list is empty.")
            : duaController.isLoading.value
            ?  Center(
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator(),
                          ),
                        )
            : ListView.builder(
              itemCount: duaController.duaList.length,
              itemBuilder: (context, index) {
                final dua = duaController.duaList[index];
                duaController.duaLanguages(dua);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors().appWhiteColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      subtitle: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: GetBuilder<BookmarkController>(
                                builder: (_) {
                                  final isMarked = bookmarkController
                                      .isDuaBookmarked(
                                        duaIndex: index,
                                        category: dua.category,
                                      );
                                  return IconButton(
                                    onPressed: () {
                                      bookmarkController.toggleDuaBookmark(
                                        duaIndex: index,
                                        duaTitle: dua.title,
                                        category: dua.category,
                                      );

                                      Get.snackbar(
                                        "BooKMark",
                                        "BookMark added ",
                                      );
                                    },
                                    icon: Row(
                                      children: [
                                        Icon(
                                          Icons.bookmark,
                                          color:
                                              isMarked
                                                  ? Colors.red
                                                  : AppColors().bookmarkColor,
                                        ),
                                        Text(
                                          dua.title,
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),

                            Text(
                              dua.arabic,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'TraditionalArabic',
                              ),
                              textAlign: TextAlign.right,
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                duaController.duaLanguage.value,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors().appTranslationColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Visibility(
                            visible: profileController.isLoggedIn.value,

                            child: PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _showEditDialog(context, dua);
                                } else if (value == 'delete') {
                                  duaController.deleteDua(dua.id!);
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
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
      }),
    );
  }

  void _showEditDialog(BuildContext context, DuaModel dua) {
    duaController.tittleController.text = dua.title;
    duaController.arabicController.text = dua.arabic;
    duaController.englishController.text = dua.english;
    duaController.tamilController.text = dua.tamil;
    duaController.uruduController.text = dua.urudu;
    duaController.hindiController.text = dua.hindi;
    duaController.malayalamController.text = dua.malayalam;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Edit Dua'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Text("Enter Dua Tittle"),
                  TextField(
                    controller: duaController.tittleController,
                    decoration: InputDecoration(hintText: "Title"),
                  ),
                  Text("Enter Dua in Arabic"),
                  TextField(
                    controller: duaController.arabicController,
                    decoration: InputDecoration(hintText: "Arabic"),
                  ),
                  Text("Enter Dua meaning in English"),
                  TextField(
                    controller: duaController.englishController,
                    decoration: InputDecoration(hintText: "English"),
                  ),
                  Text("Enter Dua meaning in Tamil"),
                  TextField(
                    controller: duaController.tamilController,
                    decoration: InputDecoration(hintText: "Tamil"),
                  ),
                  Text("Enter Dua meaning in Urudu"),
                  TextField(
                    controller: duaController.uruduController,
                    decoration: InputDecoration(hintText: "Urudu"),
                  ),
                  Text("Enter Dua meaning in Hindi"),
                  TextField(
                    controller: duaController.hindiController,
                    decoration: InputDecoration(hintText: "Hindi"),
                  ),
                  Text("Enter Dua meaning in Malayalam"),
                  TextField(
                    controller: duaController.malayalamController,
                    decoration: InputDecoration(hintText: "Malayalam"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  final updatedDua = DuaModel(
                    id: dua.id,
                    title: duaController.tittleController.text.trim(),
                    arabic: duaController.arabicController.text.trim(),
                    english: duaController.englishController.text.trim(),
                    tamil: duaController.tamilController.text.trim(),
                    urudu: duaController.uruduController.text.trim(),
                    hindi: duaController.hindiController.text.trim(),
                    malayalam: duaController.malayalamController.text.trim(),
                    category: dua.category, // keep existing category
                  );
                  duaController.updateDua(
                    updatedDua: updatedDua,
                    docId: dua.id!,
                    category: dua.category,
                  );
                  Navigator.of(context).pop();
                },
                child: Text("Update"),
              ),
            ],
          ),
    );
  }
}
