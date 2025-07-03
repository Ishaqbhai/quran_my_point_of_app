import 'package:double_tap_to_exit/double_tap_to_exit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_flutter/enums/quran_language.dart';
import 'package:quran_hadith_app/Profile/controller/profile_controller.dart';
import 'package:quran_hadith_app/Profile/view/author_login.dart';
import 'package:quran_hadith_app/bookmarks/view/bookmark_screen.dart';
import 'package:quran_hadith_app/core/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return DoubleTapToExit(
      child: PopScope(
        canPop: false,
        child: Scaffold(
          body: SizedBox(
            width: double.infinity,
            child: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(color: AppColors().appBarColor),
                    child: Text(
                      'Profile',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                  Obx(() {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: DropdownButton<QuranLanguage>(
                        value: profileController.selectedLanguage.value,
                        isExpanded: true,
                        items:
                            profileController.quranLanguages.map((language) {
                              return DropdownMenuItem<QuranLanguage>(
                                value: language,
                                child: Text(language.name),
                              );
                            }).toList(),
                        onChanged: (newLanguage) {
                          if (newLanguage != null) {
                            profileController.selectedLanguage.value =
                                newLanguage;
                          }
                        },
                      ),
                    );
                  }),
                  ListTile(
                    leading: Icon(Icons.bookmark),
                    title: Text("Bookmarks"),
                    onTap: () {
                      Get.to(() => BookmarksScreen());
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.admin_panel_settings),
                    title: Text("Admin Login"),
                    onTap: () {
                      Get.to(() => AuthorLogin());
                    },
                  ),
                  // ListTile(
                  //   leading: Icon(Icons.settings),
                  //   title: Text("Settings"),
                  //   onTap: () {
                  //     // Add settings navigation
                  //   },
                  //  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
