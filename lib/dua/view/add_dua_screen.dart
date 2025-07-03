import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_hadith_app/boarding/controller/home_controller.dart';
import 'package:quran_hadith_app/boarding/view/home_screen.dart';
import 'package:quran_hadith_app/dua/controller/dua_controller.dart';

class AddDuaScreen extends StatelessWidget {
  AddDuaScreen({super.key});
  final DuaController duaController = Get.put(DuaController());
  final HomeController homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Dua")),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Obx(() {
              return ListView(
                shrinkWrap: true,

                children: [
                  SizedBox(height: 10),
                  Text("Enter Dua Tittle"),
                  TextFormField(
                    controller: duaController.tittleController,
                    maxLines: 2,
                    decoration: InputDecoration(hintText: "Dua Tittle"),
                  ),
                  SizedBox(height: 10),
                  Text("Select Category"),
                  Obx(
                    () => DropdownButtonFormField<String>(
                      value:
                          duaController.selectedCategory.value.isNotEmpty
                              ? duaController.selectedCategory.value
                              : null,
                      items: [
                        ...duaController.categoryList.map((categoryModel) {
                          return DropdownMenuItem<String>(
                            value: categoryModel.id,
                            child: Text(categoryModel.category),
                          );
                        }),
                        const DropdownMenuItem<String>(
                          value: 'add_new',
                          child: Text("➕ Add new category"),
                        ),
                      ],
                      onChanged: (value) async {
                        if (value == 'add_new') {
                          final newCategory = await showDialog<String>(
                            context: context,
                            builder: (context) {
                              final TextEditingController categoryController =
                                  TextEditingController();
                              return AlertDialog(
                                title: Text('Add New Category'),
                                content: TextField(
                                  controller: categoryController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter category name',
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      duaController.insertDuaCategory(
                                        category:
                                            categoryController.text.trim(),
                                      );
                                      await duaController.fetchCategories();
                                      Get.back();
                                    },
                                    child: Text('Add'),
                                  ),
                                ],
                              );
                            },
                          );

                          if (newCategory != null && newCategory.isNotEmpty) {
                            await duaController.createDuaCategory(newCategory);

                            // 🆕 Refresh categories from DB after insert
                            await duaController.fetchCategories();

                            duaController.selectedCategory.value = newCategory;
                          }
                        } else if (value != null) {
                          duaController.selectedCategory.value = value;
                        }
                      },
                      decoration: InputDecoration(
                        hintText: "Choose Category",
                        prefixIcon: Icon(Icons.category),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  Text("Enter Dua in Arabic"),
                  TextFormField(
                    controller: duaController.arabicController,
                    maxLines: 2,
                    decoration: InputDecoration(hintText: "Dua in Arabic"),
                  ),
                  SizedBox(height: 10),
                  Text("Enter Dua meaning in English"),
                  TextFormField(
                    controller: duaController.englishController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: "Dua meaning in English",
                    ),
                  ),
                  SizedBox(height: 10),
                  Text("Enter Dua meaning in Tamil"),
                  TextFormField(
                    controller: duaController.tamilController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: "Dua meaning in Tamil",
                    ),
                  ),
                  SizedBox(height: 10),
                  Text("Enter Dua meaning in Urudu"),
                  TextFormField(
                    controller: duaController.uruduController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: "Dua meaning in Urudu",
                    ),
                  ),
                  SizedBox(height: 10),
                  Text("Enter Dua meaning in Hindi"),
                  TextFormField(
                    controller: duaController.hindiController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: "Dua meaning in hindi",
                    ),
                  ),
                  SizedBox(height: 10),
                  Text("Enter Dua meaning in Malayalam"),
                  TextFormField(
                    controller: duaController.malayalamController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: "Dua meaning in Malayalam",
                    ),
                  ),
                  SizedBox(height: 10),

                  /// 🔘 Save Button
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (duaController.selectedCategory.value.isEmpty) {
                          Get.snackbar("Error", "Please select a category");
                          return;
                        }
                        await duaController.saveDua();
                        homeController.changeBottomNavIndex(index: 2);
                        Get.off(HomeScreen());
                      },
                      icon: Icon(Icons.save),
                      label: Text("Save"),
                    ),
                  ),

                  if (duaController.isLoading.value)
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
    );
  }
}
