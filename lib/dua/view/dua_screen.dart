import 'package:double_tap_to_exit/double_tap_to_exit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_hadith_app/Profile/controller/profile_controller.dart';
import 'package:quran_hadith_app/core/app_colors.dart';
import 'package:quran_hadith_app/dua/controller/dua_controller.dart';
import 'package:quran_hadith_app/dua/view/add_dua_screen.dart';
import 'package:quran_hadith_app/dua/view/dua_details.dart';

class DuaScreen extends StatelessWidget {
  DuaScreen({super.key});
  final DuaController duaController = Get.put(DuaController());
  final ProfileController profileController = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    duaController.fetchCategories();
    return DoubleTapToExit(
      child: PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(
            leading: SizedBox.shrink(),
            title: Text("Dua Categories"),
          ),
          body: Obx(() {
            return duaController.categoryList.isEmpty
                ? Text("No dua categories found.")
                : duaController.isLoading.value
                ?  Center(
                          child: SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator(),
                          ),
                        )
                : ListView.builder(
                  itemCount: duaController.categoryList.length,
                  itemBuilder: (context, index) {
                    final cat = duaController.categoryList[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors().appWhiteColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          onTap: () {
                            duaController.fetchDuasByCategory(cat.id!);
                            Get.to(() => DuaDetails(categoryName: cat.id!));
                          },
                          title: Text(cat.category),

                          trailing: Visibility(
                            visible: profileController.isLoggedIn.value,
                            child: PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  _showEditDialog(
                                    context,
                                    cat.id!,
                                    cat.category,
                                  );
                                } else if (value == 'delete') {
                                  duaController.deleteDuaCategory(cat.id!);
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
                      ),
                    );
                  },
                );
          }),
          floatingActionButton: Obx(
            () => Visibility(
              visible: profileController.isLoggedIn.value,
              child: FloatingActionButton(
                onPressed: () {
                  duaController.clear();
                  Get.to(() => AddDuaScreen());
                },
                child: Text("+ Dua"),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    String id,
    String currentCategory,
  ) {
    final TextEditingController editController = TextEditingController(
      text: currentCategory,
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Edit Category'),
            content: TextFormField(
              controller: editController,
              decoration: InputDecoration(hintText: "Enter new category name"),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  final newCategory = editController.text.trim();
                  if (newCategory.isNotEmpty) {
                    Get.find<DuaController>().updateDuaCategory(
                      docId: id,
                      newCategory: newCategory,
                    );
                    Navigator.of(context).pop();
                  }
                },
                child: Text("Update"),
              ),
            ],
          ),
    );
  }
}
